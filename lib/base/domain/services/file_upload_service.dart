import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/common/failure.dart';

/// Pluggable file upload service for cloud drives (Google Drive, OneDrive, etc.)
///
/// Implementations handle uploading file/media content to a remote storage
/// provider. The [ClipSyncAdapter] calls this during outbox push to ensure
/// file data is uploaded before the clip metadata is created on the server.
abstract class FileUploadService {
  /// Upload the file associated with [item] to remote storage.
  ///
  /// Returns the updated item with [ClipboardItem.driveFileId] set on success.
  FailureOr<ClipboardItem> upload(ClipboardItem item);

  /// Whether the service is currently available (drive connected, auth valid).
  Future<bool> get isAvailable;
}
