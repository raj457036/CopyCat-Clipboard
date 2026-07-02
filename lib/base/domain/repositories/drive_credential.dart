import 'package:clipboard/base/domain/model/drive_access_token/drive_access_token.dart';
import 'package:clipboard/common/failure.dart';

abstract class DriveCredentialRepository {
  /// Fetch the drive credentials for the current user. If the user is not logged in, returns an auth failure.
  FailureOr<DriveAccessToken> getDriveCredentials();

  /// Setup the drive credentials for the current user using the provided auth code. If the user is not logged in, returns an auth failure.
  FailureOr<DriveAccessToken> setupDrive(String authCode);

  /// Refresh the drive credentials for the current user. If the user is not logged in, returns an auth failure.
  FailureOr<DriveAccessToken> refreshAccessToken();

  /// Launch OAuth flow
  FailureOr<void> launchConsentPage();
}
