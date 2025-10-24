import 'dart:async';
import 'dart:convert';

import 'package:clipboard/base/common/failure.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/drive_access_token/drive_access_token.dart';
import 'package:clipboard/base/domain/repositories/drive_credential.dart';
import 'package:dartz/dartz.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:injectable/injectable.dart';
import 'package:retry/retry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';
import 'package:url_launcher/url_launcher.dart';

@LazySingleton(as: DriveCredentialRepository)
class DriveCredentialRepositoryImpl implements DriveCredentialRepository {
  final SupabaseClient client;
  final String table = "drive_credentials";

  DriveCredentialRepositoryImpl(this.client);

  PostgrestClient get db => client.rest;

  @override
  FailureOr<void> launchConsentPage() async {
    const String clientId = googleOAuthClientID;
    const String redirectUrl = 'https://connect.entilitystudio.com';

    final url = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUrl,
      'scope': [
        DriveApi.driveAppdataScope,
      ].join(" "),
      "access_type": "offline",
      "prompt": "consent",
      "state":
          "v2", // this is used by the oauth flow for curating the redirect url
    });

    try {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
      return const Right(null);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<DriveAccessToken> getDriveCredentials() async {
    try {
      final userId = client.auth.currentSession?.user.id;

      if (userId == null) {
        return const Left(authFailure);
      }

      final query = db
          .from(table)
          .select([
            "access_token",
            "issued_at",
            "expires_in",
            "scopes",
          ].join(","))
          .eq("userId", userId);
      final doc = await query.limit(1).maybeSingle();
      if (doc == null) {
        return const Left(driveFailure);
      }
      return Right(DriveAccessToken.fromJson(doc));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<DriveAccessToken> setupDrive(String authCode) async {
    try {
      final result = await retry(
        () => client.functions
            .invoke(
              "get_gaccess_token",
              body: {"code": authCode},
              method: HttpMethod.post,
            )
            .timeout(const Duration(seconds: 30)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      return Right(DriveAccessToken.fromJson(jsonDecode(result.data)));
    } catch (e) {
      return const Left(
        Failure(
          message: "Failed to connect, please try again later!",
          code: "gcode-issue",
        ),
      );
    }
  }

  @override
  FailureOr<DriveAccessToken> refreshAccessToken() async {
    try {
      final result = await retry(
        () => client.functions
            .invoke(
              "get_gaccess_token",
              method: HttpMethod.get,
            )
            .timeout(const Duration(seconds: 30)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );
      return Right(DriveAccessToken.fromJson(jsonDecode(result.data)));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
