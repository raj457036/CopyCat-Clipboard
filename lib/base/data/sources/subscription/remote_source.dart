import 'dart:async';

import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/isar/adapters/isar_subscription.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:clipboard/base/domain/sources/subscription.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:retry/retry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:universal_io/io.dart';

@Named("remote")
@LazySingleton(as: SubscriptionSource)
class RemoteSubscriptionSource implements SubscriptionSource {
  final SupabaseClient client;
  final String table = "subscription";

  RemoteSubscriptionSource({required this.client});

  PostgrestClient get db => client.rest;
  FunctionsClient get function => client.functions;
  Isar? get localDb => Isar.getInstance(dbName);

  Future<Subscription?> _getFromDatabase(String userId) async {
    final response = await retry(
      () => db
          .from(table)
          .select()
          .eq("userId", userId)
          .maybeSingle()
          .timeout(const Duration(seconds: 15)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response == null) return null;
    final data = Map<String, dynamic>.from(response);
    return Subscription.fromJson(data);
  }

  Future<Subscription?> _getCached(String userId) async {
    final db = localDb;
    if (db == null) return null;

    final cached = await db
        .collection<IsarSubscription>()
        .filter()
        .userIdEqualTo(userId)
        .findFirst();
    return cached?.toDomain();
  }

  Future<Subscription?> _getFromRevenueCat() async {
    final response = await retry(
      () => function
          .invoke("get_rc_customer", method: HttpMethod.get)
          .timeout(const Duration(seconds: 30)),
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    final customer = CustomerInfo.fromJson(response.data["customer"]);
    return customer.toSubscription();
  }

  @override
  Future<Subscription> get(String userId) async {
    Subscription? remote;
    try {
      remote = await _getFromDatabase(userId);
      if (remote != null) {
        await save(remote);
        return remote;
      }

      final fallback = await _getFromRevenueCat();
      if (fallback != null) {
        await save(fallback);
        return fallback;
      }
    } on FunctionException catch (e) {
      final cached = await _getCached(userId);
      if (cached != null) {
        return cached;
      }
      throw Failure.fromException(e);
    } catch (e) {
      final cached = await _getCached(userId);
      if (cached != null) {
        return cached;
      }
      throw Failure.fromException(e);
    }

    final cached = await _getCached(userId);
    if (cached != null) {
      return cached;
    }

    throw const Failure(
      message: "Subscription not found",
      code: "subscription-not-found",
    );
  }

  @override
  Future<void> save(Subscription subscription) async {
    final db = localDb;
    if (db == null) return;

    await db.writeTxn(() async {
      final collection = db.collection<IsarSubscription>();
      final existing = await collection
          .filter()
          .userIdEqualTo(subscription.userId)
          .findFirst();

      final entry = IsarSubscription.fromDomain(
        subscription.copyWith(id: existing?.isarId),
      );
      await collection.put(entry);
    });
  }

  @override
  Future<Subscription> applyPromoCoupon(String code) async {
    try {
      final response = await retry(
        () => function
            .invoke(
              "apply_promo_coupon",
              body: {"code": code},
              method: HttpMethod.post,
            )
            .timeout(const Duration(seconds: 30)),
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      final customer = CustomerInfo.fromJson(
        Map<String, dynamic>.from(response.data["customer"]),
      );
      final subscription = customer.toSubscription();
      await save(subscription);
      return subscription;
    } on FunctionException catch (e) {
      throw Failure(
        message: e.details["error"] ?? "Invalid Code",
        code: "promo-failed",
      );
    }
  }
}
