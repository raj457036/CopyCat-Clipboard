import 'package:clipboard/base/domain/model/webdav_config/webdav_config.dart';
import 'package:clipboard/common/failure.dart';

abstract class WebDavCredentialRepository {
  /// Fetch the stored WebDAV configuration from local secure storage.
  FailureOr<WebDavConfig?> getConfig();

  /// Save the WebDAV configuration to local secure storage.
  FailureOr<void> saveConfig(WebDavConfig config);

  /// Delete the stored WebDAV configuration.
  FailureOr<void> deleteConfig();

  /// Test connection to the WebDAV server with the given configuration.
  FailureOr<void> testConnection(WebDavConfig config);
}
