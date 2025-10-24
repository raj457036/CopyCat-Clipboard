import 'dart:async';

import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
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
  Future<void> delete(ClipboardItem item);
  Future<void> deleteMany(List<ClipboardItem> items);

  bool isDownloading(ClipboardItem item);

  void cancelOperation(ClipboardItem item);
}

class GoogleAuthClient with http.BaseClient {
  final String accessToken;

  BehaviorSubject<(int, int)>? progress;
  int? contentLength;
  int currentBytes = 0;
  bool stopped = false;

  GoogleAuthClient(this.accessToken);

  BehaviorSubject<(int, int)> setProgressListener({int? contentLength}) {
    progress ??= BehaviorSubject<(int, int)>();
    this.contentLength ??= contentLength;
    return progress!;
  }

  void unsetProgressListener() {
    progress?.close();
    contentLength = null;
    progress = null;
  }

  @override
  void close() {
    unsetProgressListener();
    stopped = true;
    super.close();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (stopped) {
      throw StateError('Already stopped');
    }
    request.headers["Authorization"] = "Bearer $accessToken";
    final response = await request.send();
    final totalBytes = contentLength ?? 1;
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
    progress?.add((currentBytes, totalBytes));
    logger.i('Transfered: $currentBytes / $totalBytes bytes');

    return response;
  }
}
