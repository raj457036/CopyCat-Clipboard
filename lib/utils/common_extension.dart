import 'dart:math' show min;

import 'package:clipboard/base/bloc/window_action_cubit/window_action_cubit.dart';
import 'package:clipboard/base/db/subscription/subscription.dart';
import 'package:clipboard/base/domain/model/auth_user/auth_user.dart';
import 'package:clipboard/utils/monetization.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:timeago/timeago.dart' as timeago;
import 'package:window_manager/window_manager.dart';

extension WidgetStateExtension<T> on T {
  /// Convert into material state property
  WidgetStateProperty<T> get msp => WidgetStateProperty.all(this);
}

extension StringExtension on String {
  String sub({int start = 0, int? end}) {
    final end_ = min(end ?? length, length);
    return substring(start, end_);
  }

  String get title {
    if (isEmpty) return this;
    if (length == 1) return toUpperCase();
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  MediaQueryData get mq => MediaQuery.of(this);
  WindowActionCubit? get windowAction =>
      isDesktopPlatform ? read<WindowActionCubit?>() : null;
  bool get isDarkMode => theme.brightness == Brightness.dark;
  String get location {
    return GoRouter.of(this).location();
  }
}

extension EnumParserExtension<T extends Enum> on List<T> {
  T? parse(String? value, [T? default_]) {
    try {
      return firstWhere((e) => e.name == value);
    } on StateError {
      return default_;
    }
  }
}

extension ListExtension<T> on List<T> {
  List<T> replace(int index, T value) {
    if (index == -1) {
      return this;
    }

    return [...take(index), value, ...skip(index + 1)];
  }

  List<T> replaceWhere(bool Function(T value) predicate, T value) {
    final index = indexWhere(predicate);
    final result = replace(index, value);
    return result;
  }

  T getRandom() {
    final index = getRandomIndex(length);
    return this[index];
  }

  T? findFirst(bool Function(T value) predicate) {
    try {
      return firstWhere(predicate);
    } on StateError {
      return null;
    }
  }

  /// removes the item can create a new list
  List<T> removeWhereNL(bool Function(T value) predicate) {
    final index = indexWhere(predicate);
    if (index == -1) return this;
    return [...take(index), ...skip(index + 1)];
  }
}

extension DateTimeExtension on DateTime {
  bool isBetween(DateTime? start, DateTime? end) {
    bool startCrossed = true;
    bool endCrossed = true;

    if (start != null) {
      startCrossed = start.isBefore(this);
    }
    if (end != null) {
      endCrossed = end.isAfter(this);
    }

    return startCrossed && endCrossed;
  }

  bool isSameDate(DateTime? other, {bool trueIfNull = false}) {
    if (other == null) return trueIfNull;
    return other.year == year && other.month == month && other.day == day;
  }

  bool isToday() {
    return isSameDate(DateTime.now());
  }

  String ago([String? locale]) =>
      timeago.format(this, locale: "${locale}_short");
}

extension AuthUserExtension on sb.User {
  AuthUser toAuthUser() {
    return AuthUser(
      userId: id,
      email: email!,
      displayName: userMetadata?["display_name"],
      enc2KeyId: userMetadata?["enc2KeyId"],
      enc1: userMetadata?["enc1"],
    );
  }
}

extension CustomerInfoExtension on CustomerInfo {
  Subscription toSubscription() {
    final proEntitlement = entitlements.active["pro features"];
    late Subscription subscription;
    if (proEntitlement != null) {
      final activeTill = DateTime.parse(proEntitlement.expirationDate!);
      subscription = generateProPlan(
        originalAppUserId,
        activeTill,
        proEntitlement.productIdentifier == "rc_promo_pro features_custom",
        managementURL,
      );
    } else {
      subscription = generateFreePlan(originalAppUserId);
    }

    return subscription;
  }
}

extension WindowManagerExtenstion on WindowManager {
  Future<void> toggle() async {
    final isVisible_ = await isVisible();
    if (isVisible_) {
      await hide();
    } else {
      await show();
    }
  }
}

extension ColorExtensions on Color {
  String toHex(
          {bool includeHashSign = false,
          bool enableAlpha = true,
          bool toUpperCase = true}) =>
      colorToHex(
        this,
        includeHashSign: includeHashSign,
        enableAlpha: enableAlpha,
        toUpperCase: toUpperCase,
      );
}

extension GoRouterExtension on GoRouter {
  String location() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    final String? location = matchList.last.route.name;
    return location ?? "";
  }
}
