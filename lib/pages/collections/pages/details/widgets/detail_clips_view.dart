import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/widgets/app_layout_builder.dart';
import 'package:clipboard/widgets/can_paste_builder.dart';
import 'package:clipboard/widgets/clip_view_builders/builder.dart';
import 'package:clipboard/widgets/clips_provider.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';

/// Renders the clip list for a collection detail page.
/// Reads all required BLoC state from context.
class CollectionDetailClipsView extends StatelessWidget {
  const CollectionDetailClipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldBody(
      margin: const EdgeInsets.only(right: padding12, left: padding12),
      child: AppLayoutBuilder(
        builder: (context, layoutView, _) {
          return CanPasteBuilder(
            builder: (context, _) {
              return ClipsProviderWithBuilder(
                isCollectionClips: true,
                builder: (context, clips, hasMore, loading, loadMore) {
                  return ClipsBuilder(
                    items: clips,
                    hasMore: hasMore,
                    loading: loading,
                    loadMore: loadMore,
                    layoutView: layoutView,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
