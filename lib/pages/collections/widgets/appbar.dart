import 'package:clipboard/pages/collections/widgets/search_bar.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class CollectionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ValueChanged<String> onQueryChanged;

  const CollectionAppBar({super.key, required this.onQueryChanged});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: context.colors.surface,
      titleSpacing: 8,
      centerTitle: true,
      title: CollectionsSearchBar(onQueryChanged: onQueryChanged),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
