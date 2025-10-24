import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/base/domain/repositories/auth.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final sb.SupabaseClient client;

  AuthRepositoryImpl({required this.client});

  @override
  String? get userId => client.auth.currentUser?.id;

  @override
  FailureOr<(String?, AuthUser?)> validateAuthCode(String code) async {
    try {
      final exchange = await client.auth.exchangeCodeForSession(code);

      switch (exchange.redirectType) {
        case "passwordRecovery":
          return Right(
            ("passwordRecovery", exchange.session.user.toAuthUser()),
          );
        case _:
          logger.w("Exchange not supported. ${exchange.redirectType}");
      }
      return const Right((null, null));
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<void> logout() async {
    try {
      await client.auth.signOut(scope: sb.SignOutScope.local);
      return const Right(null);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<AuthUser> updateUserInfo(Map<String, dynamic> data) async {
    try {
      final result = await client.auth.updateUser(
        sb.UserAttributes(data: data),
      );
      if (result.user == null) {
        throw Exception();
      }

      return Right(result.user!.toAuthUser());
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  AuthUser? get currentUser => client.auth.currentUser?.toAuthUser();

  @override
  String? get accessToken => client.auth.currentSession?.accessToken;
}
