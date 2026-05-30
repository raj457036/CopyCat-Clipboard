import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collections/widgets/appbar.dart';
import 'package:clipboard/pages/collections/widgets/collections_grid.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/appconfig_flag.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/pro_tip_banner.dart';
import 'package:clipboard/widgets/scaffold_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode, _searchResetButtonFocus;
  String _searchQuery = '';
  bool _isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchResetButtonFocus = FocusNode(
      debugLabel: 'collection-search-reset-button',
      skipTraversal: true,
    );
    _searchFocusNode = FocusNode(
      debugLabel: 'collection-search-input',
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          node.nextFocus();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
            _searchController.text.isNotEmpty) {
          _searchResetButtonFocus.requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );
    _searchFocusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _isSearchFocused = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchResetButtonFocus.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void onQueryChanged(String text, bool typeToSearchEnabled) {
    if (typeToSearchEnabled) {
      setState(() {
        _searchQuery = text.toLowerCase();
      });
      return;
    }

    // Keep UI reactive (clear button visibility), but don't search while typing.
    setState(() {});
  }

  void onQuerySubmitted(String text) {
    setState(() {
      _searchQuery = text.toLowerCase();
    });
  }

  void clearQuery() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = context.screenSize.width;
    final isMobile = Breakpoints.isMobile(width);
    final crossAxisCount = Breakpoints.on<int>(
      width,
      default_: 1,
      tablet: 2,
      desktop: 3,
      xldesktop: 4,
      xxldesktop: 5,
    );
    return CustomScaffold(
      activeIndex: 1,
      appBar: isMobilePlatform ? const CollectionAppBar() : null,
      body: Column(
        children: [
          if (width > Breakpoints.xs)
            DisableForLocalUser(
              child: AppConfigBuilder(
                when: (c) => c.showCollectionTip,
                builder: (_) => TipTile(
                  tip: context.locale.collections__text__tip,
                  trailing: CloseButton(
                    onPressed: () =>
                        context.read<AppConfigCubit>().showCollectionTip(false),
                  ),
                ),
              ),
            ),
          height12,
          Expanded(
            child: ScaffoldBody(
              child: CollectionsGrid(
                searchQuery: _searchQuery,
                crossAxisCount: crossAxisCount,
                isMobile: isMobile,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
