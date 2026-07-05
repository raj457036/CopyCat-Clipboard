import 'package:clipboard/utils/utility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:googleapis/drive/v3.dart';

part 'drive_access_token.freezed.dart';
part 'drive_access_token.g.dart';

@freezed
abstract class DriveAccessToken with _$DriveAccessToken {
  const DriveAccessToken._();

  factory DriveAccessToken({
    @JsonKey(name: "access_token") required String accessToken,
    @JsonKey(name: "expires_in") required int expiresIn,
    @JsonKey(name: "issued_at") required DateTime issuedAt,
    @JsonKey(name: "scopes") required List<String> scopes,
    @JsonKey(name: "display_text") String? displayText,
    @JsonKey(name: "provider") String? provider,
    @JsonKey(name: "account_id") String? accountId,
  }) = _DriveAccessToken;

  factory DriveAccessToken.fromJson(Map<String, dynamic> json) =>
      _$DriveAccessTokenFromJson(json);

  bool get isExpired {
    final safeLifetime = (expiresIn - 300).clamp(0, expiresIn).toInt();
    return systemTime().isAfter(issuedAt.add(Duration(seconds: safeLifetime)));
  }

  bool get hasAllGrants => scopes.contains(DriveApi.driveAppdataScope);
}
