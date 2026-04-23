import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/failure.dart';
import 'package:flutter/material.dart';

@immutable
class TransferProgress {
  final int totalBytes;
  final int transferedBytes;

  double get progress => totalBytes > 0 ? transferedBytes / totalBytes : 0;

  const TransferProgress({
    required this.totalBytes,
    required this.transferedBytes,
  });
}

/// Pluggable file cloud service for cloud drives (Google Drive, OneDrive, etc.)
///
/// Implementations handle uploading/downloading/deleting file/media content to a remote storage
/// provider. The [ClipSyncAdapter] calls this during outbox push to ensure
/// file data is uploaded before the clip metadata is created on the server.
abstract class FileCloudService {
  /// Upload the file associated with [item] to remote storage.
  ///
  /// Returns the updated item with [ClipboardItem.driveFileId] set on success.
  FailureOr<ClipboardItem> upload(
    ClipboardItem item, {
    Stream<TransferProgress>? progress,
  });

  /// Delete the file associated with [item] from remote storage.
  ///
  /// Returns the item on success (for potential local cleanup), or failure if deletion failed.
  FailureOr<ClipboardItem> delete(ClipboardItem item);

  /// Download the file associated with [item] from remote storage.
  ///
  /// Returns the local file path on success, or failure if download failed.
  FailureOr<ClipboardItem> download(
    ClipboardItem item, {
    Stream<TransferProgress>? progress,
  });

  /// Whether the service is currently available (drive connected, auth valid).
  Future<bool> get isAvailable;
}
