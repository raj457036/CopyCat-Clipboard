import 'package:clipboard/base/bloc/clip_collection_cubit/clip_collection_cubit.dart';
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/pages/collections/widgets/appbar.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/clip_collection_grid_item.dart';
import 'package:clipboard/widgets/layout/custom_scaffold.dart';
import 'package:clipboard/widgets/local_user.dart';
import 'package:clipboard/widgets/no_collection.dart';
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

  Future<void> onRefresh(BuildContext context) async {
    await context.read<ClipCollectionCubit>().fetch(fromTop: true);
  }

  @override
  Widget build(BuildContext context) {
    final width = context.mq.size.width;
    final isMobile = Breakpoints.isMobile(width);
    final searchTopPadding = isMobile ? padding12 : padding8;
    final typeToSearchEnabled = context.select(
      (AppConfigCubit c) => c.state.config.enableTypeToSearch,
    );
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
          Padding(
            padding: EdgeInsets.fromLTRB(
              padding12,
              searchTopPadding,
              padding12,
              8,
            ),
            child: Center(
              child: AnimatedContainer(
                curve: Curves.easeIn,
                height: 40,
                width: _isSearchFocused ? 650 : 500,
                duration: Durations.short2,
                child: Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onTapOutside: (_) => _searchFocusNode.unfocus(),
                        onChanged: (text) =>
                            onQueryChanged(text, typeToSearchEnabled),
                        onSubmitted: onQuerySubmitted,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide.none,
                          ),
                          fillColor: context.colors.surfaceContainerHigh,
                          filled: true,
                          prefixIcon: const Icon(Icons.search_rounded),
                          hintText: context.locale.app__search,
                          contentPadding: const EdgeInsets.only(
                            left: padding12,
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        focusNode: _searchResetButtonFocus,
                        style: IconButton.styleFrom(
                          backgroundColor: context.colors.surfaceContainerHigh,
                        ),
                        onPressed: clearQuery,
                        icon: const Icon(Icons.clear_rounded),
                        color: context.colors.outline,
                      ),
                  ],
                ),
              ),
            ),
          ),
          if (width > 200)
            DisableForLocalUser(
              child: isMobile
                  ? TipTile(tip: context.locale.collections__text__tip)
                  : Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: TipTile(
                          tip: context.locale.collections__text__tip,
                        ),
                      ),
                    ),
            ),
          Expanded(
            child: ScaffoldBody(
              child: RefreshIndicator(
                onRefresh: () => onRefresh(context),
                child: BlocBuilder<ClipCollectionCubit, ClipCollectionState>(
                  builder: (context, state) {
                    switch (state) {
                      case ClipCollectionLoaded(loading: true):
                        return const Center(child: CircularProgressIndicator());
                      case ClipCollectionLoaded(
                        :final failure,
                        :final collections,
                      ):
                        {
                          if (failure != null) {
                            return Center(child: Text(failure.message));
                          }
                          if (collections.isEmpty) {
                            return const Center(child: NoCollectionAvailable());
                          }
                          final filtered = _searchQuery.isEmpty
                              ? collections
                              : collections.where((c) {
                                  return c.title.toLowerCase().contains(
                                        _searchQuery,
                                      ) ||
                                      (c.description?.toLowerCase().contains(
                                            _searchQuery,
                                          ) ??
                                          false);
                                }).toList();

                          if (filtered.isEmpty && _searchQuery.isNotEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search_off, size: 48),
                                  const SizedBox(height: 16),
                                  Text(context.locale.app__no_results),
                                ],
                              ),
                            );
                          }

                          const aspectRatio = 16 / 7;
                          final builder = GridView.builder(
                            cacheExtent: 300,
                            padding: isMobile
                                ? const EdgeInsets.all(padding10)
                                : inset12,
                            itemCount: filtered.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: crossAxisCount,
                                  childAspectRatio: aspectRatio,
                                  mainAxisExtent: 100,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                            itemBuilder: (BuildContext context, int index) {
                              final collection = filtered[index];
                              final isReadOnly = state.isReadOnly(collection);
                              return ClipCollectionGridItem(
                                autoFocus: isDesktopPlatform && index == 0,
                                collection: collection,
                                isReadOnly: isReadOnly,
                              );
                            },
                          );

                          return builder;
                        }
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
