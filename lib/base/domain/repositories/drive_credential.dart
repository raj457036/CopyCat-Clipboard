import 'package:clipboard/base/domain/model/drive_access_token/drive_access_token.dart';
import 'package:clipboard/common/failure.dart';

abstract class DriveCredentialRepository {
  FailureOr<DriveAccessToken> getDriveCredentials();
  FailureOr<DriveAccessToken> setupDrive(String authCode);
  FailureOr<DriveAccessToken> refreshAccessToken();
  FailureOr<void> launchConsentPage();
}
