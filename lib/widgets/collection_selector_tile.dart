import 'package:copycat_base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:copycat_base/constants/strings/route_constants.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/db/clip_collection/clipcollection.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ClipCollectionSelectorTile extends StatefulWidget {
  final int? collectionId;
  final void Function(ClipCollection? collection, {bool removed}) onChange;

  const ClipCollectionSelectorTile({
    super.key,
    this.collectionId,
    required this.onChange,
  });

  @override
  State<ClipCollectionSelectorTile> createState() =>
      ClipCollectionSelectorStateTile();
}

class ClipCollectionSelectorStateTile
    extends State<ClipCollectionSelectorTile> {
  late final ClipCollectionCubit cubit;
  bool isLoading = false;
  ClipCollection? collection;

  @override
  void initState() {
    super.initState();
    cubit = context.read<ClipCollectionCubit>();
    fetchCollection();
  }

  Future<void> fetchCollection() async {
    setState(() {
      isLoading = true;
    });
    if (widget.collectionId != null) {
      collection = await cubit.get(widget.collectionId!);
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> selectCollection() async {
    final selected = await context.pushNamed<ClipCollection>(
      RouteConstants.clipCollectionSelection,
      queryParameters: {
        "id": collection?.id.toString() ?? "",
      },
    );

    if (selected == null) return;
    setState(() {
      collection = selected;
    });
    widget.onChange(selected, removed: false);
  }

  void clear() {
    setState(() {
      collection = null;
    });
    widget.onChange(null, removed: true);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      title: collection == null
          ? Text(context.locale.collection_selector__tile__no_collection)
          : Text("${collection!.emoji} ${collection!.title}"),
      subtitle: Text(context.locale.app__change_collection),
      trailing: collection == null
          ? const Icon(Icons.chevron_right)
          : IconButton.filled(
              onPressed: clear,
              icon: const Icon(Icons.remove),
              color: colors.onPrimary,
              tooltip:
                  context.locale.collection_selector__button__remove_collection,
            ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      tileColor: colors.secondaryContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: radius8,
      ),
      onTap: isLoading ? null : selectCollection,
    );
  }
}
