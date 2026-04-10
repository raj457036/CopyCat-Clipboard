import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/clip_collection/clipcollection.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/clip_item/clip_collection_indicator_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipCollectionIndicator extends StatelessWidget {
  final int? collectionId;
  final int? serverCollectionId;

  const ClipCollectionIndicator({
    super.key,
    this.collectionId,
    this.serverCollectionId,
  });

  bool get _hasCollectionReference =>
      collectionId != null || serverCollectionId != null;

  @override
  Widget build(BuildContext context) {
    if (!_hasCollectionReference ||
        !ClipCollectionIndicatorScope.enabledOf(context)) {
      return const SizedBox.shrink();
    }

    return BlocSelector<
      ClipCollectionCubit,
      ClipCollectionState,
      ClipCollection?
    >(
      selector: (state) => state.collections.findFirst(
        (collection) => collection.id == collectionId,
      ),
      builder: (context, collection) {
        return _ClipCollectionChip(
          label: collection != null
              ? "${collection.emoji} ${collection.title}"
              : context.locale.layout__navbar__collections,
        );
      },
    );
  }
}

class _ClipCollectionChip extends StatelessWidget {
  final String label;

  const _ClipCollectionChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: padding8,
        vertical: padding4,
      ),
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: radius26,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.collections_bookmark_rounded,
            size: 14,
            color: colors.onSecondaryContainer,
          ),
          width4,
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: textTheme.labelMedium?.copyWith(
                color: colors.onSecondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
