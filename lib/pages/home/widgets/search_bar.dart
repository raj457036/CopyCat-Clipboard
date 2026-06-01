import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/search_filter_state.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/copycat_logo.dart';
import 'package:clipboard/widgets/on_event.dart';
import 'package:clipboard/widgets/search/filter_button.dart';
import 'package:clipboard/widgets/view_buttons/app_layout_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchInputBar extends StatefulWidget {
  const SearchInputBar({super.key});

  @override
  State<SearchInputBar> createState() => _SearchBarInputState();
}

class _SearchBarInputState extends State<SearchInputBar> {
  late final TextEditingController queryController;
  late final FocusNode searchInputFocusNode;
  final Debouncer _debouncer = Debouncer(milliseconds: 250);
  bool isFocused = false;

  void onFocus() {
    setState(() {
      isFocused = searchInputFocusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ClipboardCubit>();
    queryController = TextEditingController(text: cubit.state.query);
    searchInputFocusNode = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          node.focusInDirection(TraversalDirection.down);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      debugLabel: 'home-search-input',
    );
    searchInputFocusNode.addListener(onFocus);
  }

  @override
  void dispose() {
    _debouncer.cancel();
    searchInputFocusNode.removeListener(onFocus);
    queryController.dispose();
    searchInputFocusNode.dispose();
    super.dispose();
  }

  void focus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      searchInputFocusNode.requestFocus();
    });
  }

  void onSearchFocusEvent(BuildContext context, EventBusKeyboardEvent event) {
    if (event.event.name == "search") focus();
  }

  void _onQueryChanged(String text, bool typeToSearchEnabled) {
    if (!typeToSearchEnabled) {
      _debouncer.cancel();
      setState(() {}); // update clear-button visibility as user types
      return;
    }

    _debouncer(() {
      if (mounted) context.read<ClipboardCubit>().search(text);
    });
    setState(() {}); // update clear-button visibility
  }

  Future<void> _onQuerySubmitted(String text) async {
    _debouncer.cancel();
    await context.read<ClipboardCubit>().search(text);
  }

  void onFilterChange(SearchFilterState filters) {
    context.read<ClipboardCubit>().applyFilters(filters);
  }

  void clear() {
    _debouncer.cancel();
    queryController.clear();
    context.read<ClipboardCubit>().clearSearch();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final isMobile = context.isMobile;
    // Watch filter state changes to re-render clear button and filter badge.
    final filterState = context.select(
      (ClipboardCubit c) => c.state.filterState,
    );
    final typeToSearchEnabled = context.select(
      (AppConfigCubit c) => c.state.config.enableTypeToSearch,
    );
    final isActive = queryController.text.isNotEmpty || filterState.isActive;
    return AppBar(
      titleSpacing: 8,
      scrolledUnderElevation: 0.0,
      centerTitle: true,
      backgroundColor: colors.surface,
      title: OnEvent<EventBusKeyboardEvent>(
        trigger: onSearchFocusEvent,
        child: AnimatedContainer(
          curve: Curves.easeIn,
          width: isFocused ? 850 : 650,
          height: 46,
          duration: Durations.short2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [
              Expanded(
                child: Focus(
                  skipTraversal: true,
                  onFocusChange: (value) => value ? focus() : null,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: SearchBar(
                      controller: queryController,
                      focusNode: searchInputFocusNode,
                      side: isFocused
                          ? BorderSide(color: colors.outline, width: 2).msp
                          : null,
                      smartDashesType: SmartDashesType.disabled,
                      smartQuotesType: SmartQuotesType.disabled,
                      onTapOutside: (event) => searchInputFocusNode
                          .focusInDirection(TraversalDirection.down),
                      elevation: 0.0.msp,
                      hintText: context.locale.home__search__hint,
                      leading: const Align(
                        alignment: Alignment.bottomLeft,
                        child: CopyCatLogo(),
                      ),
                      backgroundColor: colors.surfaceContainerHigh.msp,
                      trailing: [
                        if (isDesktopPlatform)
                          Align(
                            widthFactor: 1,
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(right: padding10),
                              child: Text(
                                keyboardShortcut(key: "F"),
                                style: textTheme.labelLarge?.copyWith(
                                  color: colors.outline,
                                ),
                              ),
                            ),
                          ),
                      ],
                      textInputAction: TextInputAction.search,
                      onChanged: (text) =>
                          _onQueryChanged(text, typeToSearchEnabled),
                      onSubmitted: _onQuerySubmitted,
                    ),
                  ),
                ),
              ),
              if (isActive)
                IconButton(
                  focusColor: colors.secondaryContainer,
                  style: IconButton.styleFrom(
                    backgroundColor: colors.surfaceContainerHigh,
                    maximumSize: const Size.square(kToolbarHeight),
                    padding: const EdgeInsets.all(padding10),
                  ),
                  onPressed: clear,
                  icon: const Icon(Icons.clear_rounded),
                  color: colors.outline,
                  tooltip: context.locale.home__search__reset,
                ),

              if (context.screenSize.width > 250)
                FilterButton(
                  onChange: onFilterChange,
                  filterState: filterState,
                ),
              if (isMobilePlatform && isMobile && !isActive)
                const AppLayoutToggleButton(compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
