// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drive_access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DriveAccessToken _$DriveAccessTokenFromJson(Map<String, dynamic> json) =>
    _DriveAccessToken(
      accessToken: json['access_token'] as String,
      expiresIn: (json['expires_in'] as num).toInt(),
      issuedAt: DateTime.parse(json['issued_at'] as String),
      scopes: (json['scopes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      displayText: json['display_text'] as String?,
      provider: json['provider'] as String?,
      accountId: json['account_id'] as String?,
    );

Map<String, dynamic> _$DriveAccessTokenToJson(_DriveAccessToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_in': instance.expiresIn,
      'issued_at': instance.issuedAt.toIso8601String(),
      'scopes': instance.scopes,
      'display_text': instance.displayText,
      'provider': instance.provider,
      'account_id': instance.accountId,
    };
