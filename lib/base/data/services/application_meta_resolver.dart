import 'dart:async';

import 'package:clipboard/base/domain/model/application_meta/activity_meta_payload.dart';
import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/domain/repositories/application_meta.dart';
import 'package:clipboard/base/domain/services/application_meta_resolver.dart';
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

  final Map<String, ApplicationMeta?> _cache = {};

  ApplicationMetaResolverImpl(this.repo, this._focusWindow);

  @override
  String? resolveSourceId(ActivityMetaPayload? payload) {
    if (payload == null) return null;

    String? normalize(String? value) {
      final result = value?.trim();
      if (result == null || result.isEmpty) return null;
      return result.toLowerCase();
    }

    final identifier = normalize(payload.identifier);
    final appName = normalize(payload.appName);

    if (identifier != null) return identifier;
    if (appName != null) return appName;
    return null;
  }

  Future<String?> _cacheIconToFile(String sourceId, String? appFilePath) async {
    if (appFilePath == null || appFilePath.trim().isEmpty) return null;
    try {
      final bytes = await _focusWindow
          .getIcon(appFilePath)
          .timeout(const Duration(seconds: 3));
      if (bytes == null || bytes.isEmpty) return null;

      final supportDir = await getApplicationSupportDirectory();
      final iconsDir = Directory(p.join(supportDir.path, 'app_icons'));
      if (!await iconsDir.exists()) {
        await iconsDir.create(recursive: true);
      }

      // Use a filesystem-safe name derived from sourceId.
      final safeName = sourceId.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
      final iconFile = File(p.join(iconsDir.path, '$safeName.png'));
      await iconFile.writeAsBytes(bytes, flush: true);
      return iconFile.path;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String?> syncFromActivity(ActivityMetaPayload? payload) async {
    final sourceId = resolveSourceId(payload);
    if (payload == null || sourceId == null) return null;

    // Return early if we already have this record — no need to update on every copy.
    if (_cache.containsKey(sourceId) && _cache[sourceId] != null) {
      return sourceId;
    }

    final existingResult = await repo.getBySourceId(sourceId);
    final existing = existingResult.fold((_) => null, (item) => item);

    if (existing != null) {
      _cache[sourceId] = existing;
      return sourceId;
    }

    // New record — fetch icon lazily now that we know we need to persist it.
    final iconLocalPath = await _cacheIconToFile(sourceId, payload.appFilePath);

    final now = systemTime();
    final app = ApplicationMeta(
      sourceId: sourceId,
      identifier: payload.identifier?.trim().isEmpty == true
          ? null
          : payload.identifier?.trim(),
      appName: payload.appName?.trim().isEmpty == true
          ? null
          : payload.appName?.trim(),
      appFilePath: payload.appFilePath?.trim().isEmpty == true
          ? null
          : payload.appFilePath?.trim(),
      os: payload.os,
      iconLocalPath: iconLocalPath,
      created: now,
      modified: now,
    );

    final savedResult = await repo.upsert(app);
    savedResult.fold((_) {}, (saved) => _cache[sourceId] = saved);

    return sourceId;
  }

  Future<ApplicationMeta?> _getBySourceId(String sourceId) async {
    if (_cache.containsKey(sourceId)) {
      return _cache[sourceId];
    }

    final result = await repo.getBySourceId(sourceId);
    final value = result.fold((_) => null, (item) => item);
    _cache[sourceId] = value;
    return value;
  }

  @override
  Future<String?> getIconPathBySourceId(String sourceId) async {
    if (sourceId.trim().isEmpty) return null;
    final app = await _getBySourceId(sourceId);
    return app?.iconLocalPath;
  }
}
