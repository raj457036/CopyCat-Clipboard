import 'dart:async';

import 'package:android_background_clipboard/android_background_clipboard.dart';
import 'package:clipboard/base/domain/model/application_meta/activity_meta_payload.dart';
import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/domain/repositories/application_meta.dart';
import 'package:clipboard/base/domain/repositories/app_directory.dart';
import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:focus_window/focus_window.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';

@LazySingleton(as: ApplicationMetaResolver)
class ApplicationMetaResolverImpl implements ApplicationMetaResolver {
  final ApplicationMetaRepository repo;
  final FocusWindow _focusWindow;
  final AppDirectoryRepository _directoryRepo;
  final AndroidBackgroundClipboard _androidBackgroundClipboard =
      const AndroidBackgroundClipboard();

  final Map<String, ApplicationMeta?> _cache = {};
  // Guards against firing duplicate in-flight syncs for the same sourceId.
  final Set<String> _syncInFlight = {};

  ApplicationMetaResolverImpl(
    this.repo,
    this._focusWindow,
    this._directoryRepo,
  );

  String _tag(String sourceId) => '[AppMeta:$sourceId]';

  PlatformOS get _currentOs => currentPlatformOS();

  bool _isOrigin(PlatformOS? sourceOs) =>
      sourceOs != null && sourceOs == _currentOs;

  String? _normalizeValue(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) return null;
    return normalized;
  }

  Future<File> _iconFileForSource(String sourceId) async {
    final supportDir = await getApplicationSupportDirectory();
    final iconsDir = Directory(p.join(supportDir.path, 'app_icons'));
    if (!await iconsDir.exists()) {
      await iconsDir.create(recursive: true);
    }

    final safeName = sourceId.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    return File(p.join(iconsDir.path, '$safeName.png'));
  }

  Future<String?> _persistIconBytes(
    String sourceId,
    List<int>? bytes, {
    required String emptyBytesLog,
    required String successLogLabel,
  }) async {
    if (bytes == null || bytes.isEmpty) {
      logger.w('${_tag(sourceId)} $emptyBytesLog');
      return null;
    }

    final iconFile = await _iconFileForSource(sourceId);
    await iconFile.writeAsBytes(bytes, flush: true);
    return iconFile.path;
  }

  Future<ApplicationMeta?> _loadFromCacheOrLocal(String sourceId) async {
    if (_cache[sourceId]?.iconLocalPath != null) return _cache[sourceId];

    final result = await repo.getBySourceId(sourceId);
    final local = result.fold((failure) {
      logger.w('${_tag(sourceId)} local lookup failed: $failure');
      return _cache[sourceId];
    }, (item) => item);

    if (local != null && local.hasIcon) {
      _cache[sourceId] = local;
      return local;
    }
    return null;
  }

  Future<ApplicationMeta?> _fetchRemoteEntry(String sourceId) async {
    final entryResult = await _directoryRepo.fetchEntry(sourceId);
    final entry = entryResult.fold((failure) {
      logger.w('${_tag(sourceId)} remote directory fetch failed: $failure');
      return null;
    }, (e) => e);
    if (entry == null) return null;

    return ApplicationMeta(
      sourceId: sourceId,
      os: entry.os,
      iconRemotePath: entry.iconRemoteUrl,
      created: systemTime(),
      modified: systemTime(),
    );
  }

  void _cacheAndScheduleSyncIfNeeded(ApplicationMeta app) {
    _cache[app.sourceId] = app;
    if (!app.directorySynced) {
      unawaited(_syncToDirectory(app));
    }
  }

  Future<ApplicationMeta> _buildFromPayload(
    String sourceId,
    ActivityMetaPayload payload,
  ) async {
    final iconLocalPath = await _cacheIconToFile(sourceId, payload.appFilePath);
    final now = systemTime();

    return ApplicationMeta(
      sourceId: sourceId,
      identifier: _normalizeValue(payload.identifier),
      appName: _normalizeValue(payload.appName),
      appFilePath: _normalizeValue(payload.appFilePath),
      os: payload.os,
      iconLocalPath: iconLocalPath,
      created: now,
      modified: now,
    );
  }

  @override
  String? resolveSourceId(ActivityMetaPayload? payload) {
    if (payload == null) return null;

    final identifier = _normalizeValue(payload.identifier)?.toLowerCase();
    final appName = _normalizeValue(payload.appName)?.toLowerCase();

    if (identifier != null) return identifier;
    if (appName != null) return appName;
    logger.w(
      '[AppMeta] resolveSourceId failed: missing identifier and appName',
    );
    return null;
  }

  Future<String?> _cacheIconToFile(String sourceId, String? appFilePath) async {
    final normalizedPath = _normalizeValue(appFilePath);
    if (normalizedPath == null) return null;

    try {
      final bytes = await _focusWindow
          .getIcon(normalizedPath)
          .timeout(const Duration(seconds: 3));
      return await _persistIconBytes(
        sourceId,
        bytes,
        emptyBytesLog: 'focus_window returned empty icon bytes',
        successLogLabel: 'icon cached at',
      );
    } catch (e) {
      logger.w('${_tag(sourceId)} cache icon failed: $e');
      return null;
    }
  }

  Future<String?> _cacheIconByIdentifierToFile(String sourceId) async {
    try {
      final bytes = await _focusWindow
          .getIconByIdentifier(sourceId)
          .timeout(const Duration(seconds: 3));
      return await _persistIconBytes(
        sourceId,
        bytes,
        emptyBytesLog: 'identifier icon lookup returned empty bytes',
        successLogLabel: 'identifier icon cached at',
      );
    } catch (e) {
      logger.w('${_tag(sourceId)} identifier icon lookup failed: $e');
      return null;
    }
  }

  Future<String?> _cacheAndroidPackageIconToFile(String sourceId) async {
    try {
      return await _androidBackgroundClipboard.getCachedPackageIconPath(
        sourceId,
      );
    } catch (e) {
      logger.w('${_tag(sourceId)} android package icon lookup failed: $e');
      return null;
    }
  }

  Future<ApplicationMeta> _saveResolvedIcon(
    String sourceId,
    String iconLocalPath,
  ) async {
    final now = systemTime();
    final existingResult = await repo.getBySourceId(sourceId);
    var rebuilt = existingResult.fold(
      (failure) {
        logger.w('${_tag(sourceId)} local lookup before icon save failed: $failure');
        return ApplicationMeta(
          sourceId: sourceId,
          os: _currentOs,
          iconLocalPath: iconLocalPath,
          created: now,
          modified: now,
        );
      },
      (existing) =>
          existing?.copyWith(iconLocalPath: iconLocalPath, modified: now) ??
          ApplicationMeta(
            sourceId: sourceId,
            os: _currentOs,
            iconLocalPath: iconLocalPath,
            created: now,
            modified: now,
          ),
    );

    final saveResult = await repo.upsert(rebuilt);
    saveResult.fold(
      (failure) => logger.w(
        '${_tag(sourceId)} save after local icon lookup failed: $failure',
      ),
      (saved) => rebuilt = saved,
    );
    _cacheAndScheduleSyncIfNeeded(rebuilt);
    return rebuilt;
  }

  @override
  Future<String?> syncFromActivity(ActivityMetaPayload? payload) async {
    final sourceId = resolveSourceId(payload);
    if (payload == null || sourceId == null) return null;

    final local = await _loadFromCacheOrLocal(sourceId);
    if (local != null) {
      _cacheAndScheduleSyncIfNeeded(local);
      return sourceId;
    }

    final app = await _buildFromPayload(sourceId, payload);

    final savedResult = await repo.upsert(app);
    savedResult.fold(
      (failure) {
        logger.w('${_tag(sourceId)} local upsert failed: $failure');
      },
      (saved) {
        _cacheAndScheduleSyncIfNeeded(saved);
      },
    );

    return sourceId;
  }

  Future<void> _syncToDirectory(ApplicationMeta app) async {
    if (_syncInFlight.contains(app.sourceId)) return;

    if (app.directorySynced) return;

    _syncInFlight.add(app.sourceId);
    try {
      final result = await _directoryRepo.sync(app);
      final iconRemotePath = result.fold((failure) {
        logger.w('${_tag(app.sourceId)} remote sync failed: $failure');
        return null;
      }, (url) => url);

      final updated = app.copyWith(
        iconRemotePath: iconRemotePath,
        modified: systemTime(),
      );
      final saveResult = await repo.upsert(updated);
      saveResult.fold(
        (failure) {
          logger.w('${_tag(app.sourceId)} save-after-sync failed: $failure');
        },
        (saved) {
          _cache[app.sourceId] = saved;
        },
      );
    } catch (e) {
      logger.e("Failed to sync app metadata for sourceId ${app.sourceId}: $e");
    } finally {
      _syncInFlight.remove(app.sourceId);
    }
  }

  Future<ApplicationMeta?> _getBySourceId(
    String sourceId, {
    PlatformOS? sourceOs,
  }) async {
    // 1) Check local repository/cache first.
    var local = await _loadFromCacheOrLocal(sourceId);
    if (local != null) return local;

    // 2.1) Local miss + same OS => try identifier-based local OS icon lookup.
    if (_isOrigin(sourceOs)) {
      final iconLocalPath = _currentOs == PlatformOS.android
          ? await _cacheAndroidPackageIconToFile(sourceId)
          : await _cacheIconByIdentifierToFile(sourceId);
      if (iconLocalPath != null) {
        return _saveResolvedIcon(sourceId, iconLocalPath);
      }
    }

    // 2.2) Local miss + different OS => fetch from directory database.
    final remote = await _fetchRemoteEntry(sourceId);
    if (remote != null) {
      ApplicationMeta resolvedRemote = remote;
      final saveResult = await repo.upsert(remote);
      saveResult.fold(
        (failure) => logger.w(
          '${_tag(sourceId)} save remote entry locally failed: $failure',
        ),
        (saved) => resolvedRemote = saved,
      );
      _cache[sourceId] = resolvedRemote;
      return resolvedRemote;
    }

    // 3) Nothing found locally or remotely.
    _cache[sourceId] = null;
    return null;
  }

  @override
  Future<String?> getIconPathBySourceId(
    String sourceId, {
    PlatformOS? sourceOs,
  }) async {
    if (sourceId.trim().isEmpty) return null;

    final app = await _getBySourceId(sourceId, sourceOs: sourceOs);
    return app?.iconLocalPath ?? app?.iconRemotePath;
  }
}
