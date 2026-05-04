import 'package:clipboard/base/bloc/monetization_cubit/monetization_cubit.dart';
import 'package:clipboard/base/domain/model/subscription/subscription.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef SubscriptionWidgetBuilder =
    Widget Function(BuildContext context, Subscription? subscription);

class SubscriptionBuilder extends StatelessWidget {
  final SubscriptionWidgetBuilder builder;

  const SubscriptionBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MonetizationCubit, MonetizationState, Subscription?>(
      selector: (state) {
        return state.whenOrNull(
          active: (subscription) {
            return subscription;
          },
        );
      },
      builder: builder,
    );
  }
}

typedef HasAccessWidgetBuilder =
    Widget Function(
      BuildContext context,
      bool hasAccess,
      Subscription? subscription,
    );

/// A widget that conditionally shows content based on the user's subscription status.
class HasAccessToFeature extends StatelessWidget {
  final HasAccessWidgetBuilder builder;

  /// A widget to conditionally show content based
  /// on the user's subscription status.
  final Widget? fallbackWidget;

  /// when true, the builder will be called even if the user doesn't have
  /// access, with hasAccess=false.
  /// When false, the builder will only be called if the user has access,
  /// otherwise fallbackWidget will be shown.
  final bool alwaysBuild;

  final bool Function(Subscription subscription) hasAccess;

  const HasAccessToFeature({
    super.key,
    required this.builder,
    required this.hasAccess,
    this.alwaysBuild = true,
    this.fallbackWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<MonetizationCubit, MonetizationState, Subscription?>(
      selector: (state) {
        return state.whenOrNull(active: (subscription) => subscription);
      },
      builder: (context, subscription) {
        final hasAccess_ = subscription != null && hasAccess(subscription);

        if (alwaysBuild || hasAccess_) {
          return builder(context, hasAccess_, subscription);
        }
        return fallbackWidget ?? const SizedBox.shrink();
      },
    );
  }
}
