import 'dart:async';
import 'dart:io' as io;

import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/base/enums/platform_os.dart';

import 'lan_clip_builder.dart';
import 'lan_constants.dart';
import 'lan_hmac.dart';
import 'lan_peer_registry.dart';
import 'lan_receiver.dart';
import 'lan_sync_config.dart';

/// Dispatches incoming HTTP requests to the appropriate handler.
///
/// Responsibilities:
/// - `GET /ping` — health check + reverse peer learning
/// - `POST /clip` — authenticate and route to text or binary processing
class LanHttpHandler {
  final LanSyncConfig _config;
  final LanPeerRegistry _registry;
  final LanHmac _hmac;
  final LanReceiver _receiver;

  const LanHttpHandler(
    this._config,
    this._registry,
    this._hmac,
    this._receiver,
  );

  Future<void> handle(io.HttpRequest request) async {
    if (request.method == 'GET' && request.uri.path == '/ping') {
      await _handlePing(request);
      return;
    }

    if (request.method == 'POST' && request.uri.path == '/clip') {
      await _handleClip(request);
      return;
    }

    request.response
      ..statusCode = io.HttpStatus.notFound
      ..close();
  }

  // MARK: - /ping

  Future<void> _handlePing(io.HttpRequest request) async {
    final annDid = request.headers.value('x-cc-did') ?? '';
    final annPort = int.tryParse(request.headers.value('x-cc-port') ?? '');
    final annOs = LanClipBuilder.parseOS(request.headers.value('x-cc-os'));

    if (annDid.isNotEmpty && annDid != _config.deviceId && annPort != null) {
      final host = request.connectionInfo?.remoteAddress.address ?? '';
      if (host.isNotEmpty) {
        final changed = _registry.recordPeer(annDid, host, annPort, os: annOs);
        if (changed) {
          unawaited(_registry.save());
          logger.i(
            () => 'LAN: learned peer $annDid at $host:$annPort via /ping',
          );
        }
      }
    }

    request.response
      ..statusCode = io.HttpStatus.ok
      ..close();
  }

  // MARK: - /clip

  Future<void> _handleClip(io.HttpRequest request) async {
    final fromDeviceId = request.headers.value('x-cc-did') ?? '';
    if (fromDeviceId.isEmpty || fromDeviceId == _config.deviceId) {
      _badRequest(request);
      return;
    }

    final originId = request.headers.value('x-cc-oid') ?? '';
    final typeStr = request.headers.value('x-cc-type') ?? '';
    final hmacHeader = request.headers.value('x-cc-hmac') ?? '';
    final fromOs = LanClipBuilder.parseOS(request.headers.value('x-cc-os'));

    if (originId.isEmpty || typeStr.isEmpty || hmacHeader.isEmpty) {
      _badRequest(request);
      return;
    }

    final contentLength = int.tryParse(
      request.headers.value('content-length') ?? '',
    );
    if (contentLength == null || contentLength <= 0) {
      _badRequest(request);
      return;
    }

    final clipType = LanClipBuilder.parseClipType(typeStr);
    if (clipType == null) {
      _badRequest(request);
      return;
    }

    if (clipType == ClipItemType.media || clipType == ClipItemType.file) {
      await _handleBinaryClip(
        request: request,
        fromDeviceId: fromDeviceId,
        originId: originId,
        clipType: clipType,
        hmacHeader: hmacHeader,
        contentLength: contentLength,
        fromOs: fromOs,
      );
    } else {
      if (contentLength > kLanMaxTextPayloadBytes) {
        _badRequest(request);
        return;
      }
      await _handleTextClip(
        request: request,
        fromDeviceId: fromDeviceId,
        originId: originId,
        clipType: clipType,
        hmacHeader: hmacHeader,
        fromOs: fromOs,
      );
    }
  }

  Future<void> _handleBinaryClip({
    required io.HttpRequest request,
    required String fromDeviceId,
    required String originId,
    required ClipItemType clipType,
    required String hmacHeader,
    required int contentLength,
    required PlatformOS? fromOs,
  }) async {
    final fileExt = request.headers.value('x-cc-ext');
    final fileName = request.headers.value('x-cc-name');
    final fileMimeType =
        request.headers.value('x-cc-mime') ??
        request.headers.contentType?.mimeType;
    final tsMs = int.tryParse(request.headers.value('x-cc-ts') ?? '');
    final createdMs = int.tryParse(request.headers.value('x-cc-created') ?? '');
    final modifiedMs = int.tryParse(
      request.headers.value('x-cc-modified') ?? '',
    );
    final osStr = request.headers.value('x-cc-os');

    if (tsMs != null &&
        LanReceiver.isReplayTimestamp(tsMs, kLanBinaryReplayWindowMs)) {
      logger.w(
        () => 'LAN: Binary replay detected from $fromDeviceId, dropping',
      );
      request.response
        ..statusCode = io.HttpStatus.unauthorized
        ..close();
      return;
    }

    final savedFile = await _receiver.saveIncomingBinaryClip(
      request: request,
      contentLength: contentLength,
      originId: originId,
      expectedHmac: hmacHeader,
      hmac: _hmac,
    );
    if (savedFile == null) {
      request.response
        ..statusCode = io.HttpStatus.unauthorized
        ..close();
      return;
    }

    _learnPeerFromClipHeaders(request, fromDeviceId, fromOs);

    request.response
      ..statusCode = io.HttpStatus.ok
      ..close();

    _receiver.processBinaryClip(
      file: savedFile,
      fromDeviceId: fromDeviceId,
      originId: originId,
      type: clipType,
      tsMs: tsMs,
      fileExt: fileExt,
      fileName: fileName,
      fileMimeType: fileMimeType,
      createdMs: createdMs,
      modifiedMs: modifiedMs,
      osStr: osStr,
    );
  }

  Future<void> _handleTextClip({
    required io.HttpRequest request,
    required String fromDeviceId,
    required String originId,
    required ClipItemType clipType,
    required String hmacHeader,
    required PlatformOS? fromOs,
  }) async {
    final bodyBytes = await request.fold<List<int>>(
      [],
      (buf, chunk) => buf..addAll(chunk),
    );

    if (bodyBytes.length > kLanMaxTextPayloadBytes) {
      request.response
        ..statusCode = io.HttpStatus.requestEntityTooLarge
        ..close();
      return;
    }

    if (!_hmac.verify(bodyBytes, hmacHeader)) {
      logger.w(() => 'LAN: HMAC verification failed from $fromDeviceId');
      request.response
        ..statusCode = io.HttpStatus.unauthorized
        ..close();
      return;
    }

    _learnPeerFromClipHeaders(request, fromDeviceId, fromOs);

    request.response
      ..statusCode = io.HttpStatus.ok
      ..close();

    _receiver.processTextClip(
      bodyBytes: bodyBytes,
      fromDeviceId: fromDeviceId,
      originId: originId,
    );
  }

  // MARK: - Helpers

  /// Reverse peer learning: the sender includes its own HTTP server port in
  /// every /clip request so we can send clips back without waiting for mDNS.
  void _learnPeerFromClipHeaders(
    io.HttpRequest request,
    String fromDeviceId,
    PlatformOS? fromOs,
  ) {
    final inboundPort = int.tryParse(request.headers.value('x-cc-port') ?? '');
    if (inboundPort == null) return;
    final host = request.connectionInfo?.remoteAddress.address ?? '';
    if (host.isEmpty) return;
    final changed = _registry.recordPeer(
      fromDeviceId,
      host,
      inboundPort,
      os: fromOs,
    );
    if (changed) {
      unawaited(_registry.save());
      logger.i(
        () =>
            'LAN: learned peer $fromDeviceId at $host:$inboundPort from /clip',
      );
    }
  }

  void _badRequest(io.HttpRequest request) {
    request.response
      ..statusCode = io.HttpStatus.badRequest
      ..close();
  }
}
