import 'package:clipboard/base/domain/model/application_meta/app_directory_entry.dart';
import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/common/failure.dart';

abstract class AppDirectoryRepository {
  /// Syncs [app] to the remote app_activity_directory.
  /// Returns the remote icon URL on success, null if the entry has no icon.
  FailureOr<String?> sync(ApplicationMeta app);

  /// Looks up the directory entry for [sourceId] in the remote directory
  /// without requiring a local [ApplicationMeta] record.
  /// Returns [AppDirectoryEntry] with os and iconRemoteUrl.
  /// Used by devices that don't have a local record for the app.
  FailureOr<AppDirectoryEntry?> fetchEntry(String sourceId);
}
