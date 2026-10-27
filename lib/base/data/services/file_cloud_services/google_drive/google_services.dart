import 'dart:async';

import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';

abstract class DriveService {
  String? accessToken;

  FailureOr<ClipboardItem> upload(
    ClipboardItem item, {
    void Function(int, int)? onProgress,
  });
  FailureOr<ClipboardItem> download(
    ClipboardItem item, {
    void Function(int, int)? onProgress,
  });

  /// Deletes the file associated with [item] from drive and return success status.
  Future<bool> delete(ClipboardItem item);

  /// Deletes multiple items from drive. Returns the count of successfully deleted items.
  Future<int> deleteMany(List<ClipboardItem> items);

  bool isDownloading(ClipboardItem item);

  void cancelOperation(ClipboardItem item);
}

class GoogleAuthClient with http.BaseClient {
  final String accessToken;
  final http.Client _client;
  final Duration _requestTimeout;

  BehaviorSubject<int>? progress;
  int currentBytes = 0;
  bool stopped = false;

  GoogleAuthClient(
    this.accessToken, {
    http.Client? client,
    Duration requestTimeout = const Duration(minutes: 2),
  }) : _client = client ?? http.Client(),
       _requestTimeout = requestTimeout;

  BehaviorSubject<int> setProgressListener() {
    progress ??= BehaviorSubject<int>();
    return progress!;
  }

  void unsetProgressListener() {
    progress?.close();
    progress = null;
  }

  @override
  void close() {
    if (stopped) return;
    unsetProgressListener();
    stopped = true;
    _client.close();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (stopped) {
      throw StateError('Already stopped');
    }
    request.headers["Authorization"] = "Bearer $accessToken";
    final response = await _client
        .send(request)
        .timeout(
          _requestTimeout,
          onTimeout: () {
            close();
            throw TimeoutException(
              'Google Drive request timed out. Please retry.',
            );
          },
        );
    int currentLength = 0;

    // "range" -> "bytes=0-5505023" // upload
    final range = response.headers["range"];
    if (range != null) {
      final start = int.parse(range.split("=")[1].split("-")[0]);
      final end = int.parse(range.split("=")[1].split("-")[1]);
      if (start == 0) {
        currentLength = end;
      } else {
        currentLength = (end - start + 1) + currentBytes;
      }
    }

    if (currentLength > currentBytes) {
      currentBytes = currentLength;
    }
    progress?.add((currentBytes));
    logger.d(() => 'Transfered: $currentBytes bytes');

    return http.StreamedResponse(
      response.stream.timeout(
        _requestTimeout,
        onTimeout: (sink) {
          close();
          sink.addError(
            TimeoutException('Google Drive response stalled. Please retry.'),
          );
          sink.close();
        },
      ),
      response.statusCode,
      contentLength: response.contentLength,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
