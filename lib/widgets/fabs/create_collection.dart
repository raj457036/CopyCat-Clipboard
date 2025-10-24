import 'dart:math' show max;

import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/numbers/values.dart';
import 'package:clipboard/base/constants/strings/route_constants.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CreateCollectionButton extends StatelessWidget {
  final bool isFab;
  final bool localMode;
  final bool hideIfCantCreate;
  const CreateCollectionButton({
    super.key,
    this.isFab = true,
    this.localMode = false,
    this.hideIfCantCreate = false,
  });

  void createCollection(BuildContext context) {
    context.pushNamed(
      RouteConstants.createEditCollection,
      pathParameters: {"id": "new"},
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SubscriptionBuilder(
      builder: (context, subscription) {
        return BlocSelector<ClipCollectionCubit, ClipCollectionState,
            (int, int)>(
          selector: (state) {
            if (state is ClipCollectionLoaded) {
              return (
                subscription?.collections ?? defaultCollectionCount,
                state.collections.length
              );
            }
            return (subscription?.collections ?? defaultCollectionCount, 0);
          },
          builder: (context, state) {
            final (collection, count) = state;
            final canCreate = localMode || collection > count;

            if (hideIfCantCreate) return const SizedBox.shrink();

            final remaining =
                localMode ? "∞" : max(collection - count, 0).toString();
            Widget child;
            if (!isFab) {
              child = IconButton.filledTonal(
                onPressed: canCreate ? () => createCollection(context) : null,
                icon: const Icon(Icons.add),
                tooltip: context.locale.fab__create_collection(
                  remaining: remaining,
                ),
              );
            } else {
              child = FloatingActionButton(
                heroTag: "collection-fab",
                backgroundColor: canCreate ? null : colors.outline,
                mouseCursor: canCreate ? null : SystemMouseCursors.forbidden,
                onPressed: canCreate ? () => createCollection(context) : null,
                tooltip: context.locale.fab__create_collection(
                  remaining: remaining,
                ),
                child: const Icon(Icons.library_add_rounded),
              );
            }

            if (!canCreate) {
              child = Stack(
                clipBehavior: Clip.none,
                children: [
                  child,
                  const Positioned(
                    bottom: -6,
                    left: 0,
                    right: 0,
                    child: ProBadge(noTooltip: true),
                  ),
                ],
              );
            }

            return child;
          },
        );
      },
    );
  }
}
