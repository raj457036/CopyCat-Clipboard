import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/services/clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/services/sync_event_bus.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:crypto/crypto.dart';

import 'lan_clip_builder.dart';
import 'lan_constants.dart';
import 'lan_hmac.dart';
import 'lan_sync_config.dart';

/// Processes incoming LAN sync clips (both text/URL and binary file/media).
class LanReceiver {
  final LanSyncConfig _config;
  final ClipBatchSyncService _batchSync;
  final SyncEventBus _syncEventBus;
  final LanClipBuilder _clipBuilder;

  const LanReceiver(
    this._config,
    this._batchSync,
    this._syncEventBus,
    this._clipBuilder,
  );

  // MARK: - Text / URL

  /// Decode, validate, and persist an incoming text-or-URL clip.
  void processTextClip({
    required List<int> bodyBytes,
    required String fromDeviceId,
    required String originId,
  }) {
    unawaited(
      _processTextClipAsync(
        bodyBytes: bodyBytes,
        fromDeviceId: fromDeviceId,
        originId: originId,
      ),
    );
  }

  Future<void> _processTextClipAsync({
    required List<int> bodyBytes,
    required String fromDeviceId,
    required String originId,
  }) async {
    try {
      final bodyStr = utf8.decode(bodyBytes);
      final json = jsonDecode(bodyStr) as Map<String, dynamic>;

      final ts = json['ts'] as int? ?? 0;
      if (isReplayTimestamp(ts, kLanReplayWindowMs)) {
        logger.w(() => 'LAN: Replay detected from $fromDeviceId, dropping');
        return;
      }

      final item = _clipBuilder.buildFromPayload(
        json: json,
        fromDeviceId: fromDeviceId,
        originId: originId,
      );

      if (item == null) return;

      final decrypted = await item.decrypt();
      final events = await _batchSync.syncBatch([decrypted], {});
      _syncEventBus.emit<ClipboardItem>(events.first);
      logger.d(
        () => 'LAN: processed clip from $fromDeviceId originId=$originId',
      );
    } catch (e) {
      logger.e(() => 'LAN: Failed to process incoming clip: $e');
    }
  }

  // MARK: - Binary (media / file)

  /// Process and persist an incoming binary clip.
  ///
  /// [file] must already be saved to disk (see [saveIncomingBinaryClip]).
  void processBinaryClip({
    required io.File file,
    required String fromDeviceId,
    required String originId,
    required ClipItemType type,
    int? tsMs,
    String? fileExt,
    String? fileName,
    String? fileMimeType,
    int? createdMs,
    int? modifiedMs,
    String? osStr,
  }) {
    if (tsMs != null && isReplayTimestamp(tsMs, kLanBinaryReplayWindowMs)) {
      logger.w(
        () => 'LAN: Binary replay detected from $fromDeviceId, dropping',
      );
      return;
    }
    unawaited(
      _processBinaryClipAsync(
        file: file,
        fromDeviceId: fromDeviceId,
        originId: originId,
        type: type,
        fileExt: fileExt,
        fileName: fileName,
        fileMimeType: fileMimeType,
        createdMs: createdMs,
        modifiedMs: modifiedMs,
        osStr: osStr,
      ),
    );
  }

  Future<void> _processBinaryClipAsync({
    required io.File file,
    required String fromDeviceId,
    required String originId,
    required ClipItemType type,
    String? fileExt,
    String? fileName,
    String? fileMimeType,
    int? createdMs,
    int? modifiedMs,
    String? osStr,
  }) async {
    try {
      final now = systemTime();
      final itemCreated = createdMs != null
          ? DateTime.fromMillisecondsSinceEpoch(createdMs)
          : now;
      final itemModified = modifiedMs != null
          ? DateTime.fromMillisecondsSinceEpoch(modifiedMs)
          : now;
      final itemOs = LanClipBuilder.parseOS(osStr) ?? PlatformOS.android;
      final actualType =
          (fileMimeType?.startsWith('image/') == true &&
              type == ClipItemType.file)
          ? ClipItemType.media
          : type;
      final extFromPath = p.extension(file.path).replaceFirst('.', '');
      final ext = (fileExt?.isNotEmpty == true)
          ? fileExt!
          : (extFromPath.isNotEmpty ? extFromPath : 'bin');
      final name = (fileName?.isNotEmpty == true)
          ? fileName!
          : p.basename(file.path);
      final fileSize = await file.length();

      final userId = _config.userId.isNotEmpty ? _config.userId : kLocalUserId;
      final item = ClipboardItem(
        userId: userId,
        deviceId: fromDeviceId.isNotEmpty ? fromDeviceId : null,
        type: actualType,
        localPath: file.path,
        fileName: name,
        title: name,
        fileExtension: ext,
        fileMimeType: fileMimeType,
        fileSize: fileSize,
        created: itemCreated,
        modified: itemModified,
        os: itemOs,
        originId: originId,
      );

      final events = await _batchSync.syncBatch([item], {});
      if (events.isNotEmpty) {
        _syncEventBus.emit<ClipboardItem>(events.first);
      }
      logger.d(
        () =>
            'LAN: binary clip from $fromDeviceId '
            '— type=${type.name} size=$fileSize saved=${file.path}',
      );
    } catch (e) {
      logger.e(() => 'LAN: Failed to process incoming binary clip: $e');
    }
  }

  // MARK: - Binary streaming helper

  /// Stream a binary request body to a temp file, verify its HMAC on the fly,
  /// and return the final [io.File] on success (null on any failure).
  Future<io.File?> saveIncomingBinaryClip({
    required io.HttpRequest request,
    required int contentLength,
    required String originId,
    required String expectedHmac,
    required LanHmac hmac,
  }) async {
    final fileMimeType =
        request.headers.value('x-cc-mime') ??
        request.headers.contentType?.mimeType;
    final fileExt = request.headers.value('x-cc-ext');
    final fileName = request.headers.value('x-cc-name');
    final clipType =
        LanClipBuilder.parseClipType(
          request.headers.value('x-cc-type') ?? '',
        ) ??
        ClipItemType.file;
    final actualType =
        (fileMimeType?.startsWith('image/') == true &&
            clipType == ClipItemType.file)
        ? ClipItemType.media
        : clipType;
    final rootDir = actualType == ClipItemType.media ? 'medias' : 'files';
    // Sanitize to prevent path traversal: strip non-alphanumeric chars from
    // the extension and originId before composing file-system paths.
    final rawExt = (fileExt?.trim().isNotEmpty == true)
        ? fileExt!.trim()
        : 'bin';
    final cleanExt = rawExt.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final ext = cleanExt.isEmpty ? 'bin' : cleanExt;
    final safeOriginId = originId.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '_');
    final name = (fileName?.trim().isNotEmpty == true)
        ? p.basename(fileName!.trim())
        : '$safeOriginId.$ext';

    final digests = <Digest>[];
    final macSink = Hmac(sha256, utf8.encode(_config.userId))
        .startChunkedConversion(
          ChunkedConversionSink.withCallback(digests.addAll),
        );

    final docDir = await getApplicationDocumentsDirectory();
    final dir = io.Directory(p.join(docDir.path, 'offline', rootDir));
    await dir.create(recursive: true);

    final tempFile = io.File(
      p.join(
        dir.path,
        '${safeOriginId}_${DateTime.now().millisecondsSinceEpoch}.part',
      ),
    );
    final sink = tempFile.openWrite();
    var receivedBytes = 0;

    try {
      await for (final chunk in request) {
        receivedBytes += chunk.length;
        if (receivedBytes > contentLength) {
          logger.w(
            () => 'LAN: Received body larger than declared size for $originId',
          );
          macSink.close();
          await sink.close();
          await _tryDelete(tempFile);
          return null;
        }
        sink.add(chunk);
        macSink.add(chunk);
      }

      await sink.close();
      macSink.close();

      if (receivedBytes != contentLength) {
        logger.w(
          () =>
              'LAN: Short streamed body for $originId: '
              'expected=$contentLength got=$receivedBytes',
        );
        await _tryDelete(tempFile);
        return null;
      }

      if (digests.isEmpty) {
        logger.w(() => 'LAN: Missing HMAC digest after streaming $originId');
        await _tryDelete(tempFile);
        return null;
      }

      if (!hmac.verifyDigest(digests.single, expectedHmac)) {
        logger.w(
          () =>
              'LAN: HMAC verification failed from '
              '${request.headers.value('x-cc-did') ?? ''}',
        );
        await _tryDelete(tempFile);
        return null;
      }

      final finalPath = p.join(dir.path, '${safeOriginId}_$name');
      final finalFile = io.File(finalPath);
      if (await finalFile.exists()) await finalFile.delete();
      await tempFile.rename(finalPath);
      return finalFile;
    } catch (e) {
      macSink.close();
      await sink.close();
      await _tryDelete(tempFile);
      logger.w(() => 'LAN: Failed to stream binary clip for $originId: $e');
      return null;
    }
  }

  Future<void> _tryDelete(io.File f) async {
    try {
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  // MARK: - Replay guard

  /// Returns true when [ts] is older than [windowMs] milliseconds.
  static bool isReplayTimestamp(int ts, int windowMs) =>
      DateTime.now().millisecondsSinceEpoch - ts > windowMs;
}
