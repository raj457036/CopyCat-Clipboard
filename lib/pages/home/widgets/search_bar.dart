import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/numbers/breakpoints.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/search_filter_state.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:clipboard/utils/utility.dart';
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
  late final FocusNode focusNode, searchResetButtonFocus;
  final Debouncer _debouncer = Debouncer(milliseconds: 250);
  bool isFocused = false;

  void onFocus() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ClipboardCubit>();
    queryController = TextEditingController(text: cubit.state.query);
    searchResetButtonFocus = FocusNode(
      debugLabel: "search-reset-button",
      skipTraversal: true,
    );
    focusNode = FocusNode(
      debugLabel: "searchbar-input",
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          node.nextFocus();
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
          searchResetButtonFocus.requestFocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
    );
    focusNode.addListener(onFocus);
  }

  @override
  void dispose() {
    _debouncer.cancel();
    focusNode.removeListener(onFocus);
    queryController.dispose();
    focusNode.dispose();
    searchResetButtonFocus.dispose();
    super.dispose();
  }

  void focus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
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

  void _onQuerySubmitted(String text) {
    _debouncer.cancel();
    context.read<ClipboardCubit>().search(text);
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
    final size = context.mq.size;
    // Watch filter state changes to re-render clear button and filter badge.
    final filterState = context.select(
      (ClipboardCubit c) => c.state.filterState,
    );
    final typeToSearchEnabled = context.select(
      (AppConfigCubit c) => c.state.config.enableTypeToSearch,
    );
    final isActive = queryController.text.isNotEmpty || filterState.isActive;
    return OnEvent<EventBusKeyboardEvent>(
      trigger: onSearchFocusEvent,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        height: 40,
        width: isFocused ? 650 : 500,
        duration: Durations.short2,
        child: Row(
          spacing: 4,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                autofocus: false,
                controller: queryController,
                focusNode: focusNode,
                onTapOutside: (event) => focusNode.nextFocus(),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: colors.surfaceContainerHigh,
                  filled: true,
                  suffixIcon: isDesktopPlatform
                      ? Align(
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
                        )
                      : null,
                  prefixIcon: const Icon(Icons.search_rounded),
                  hintText: context.locale.home__search__hint,
                  contentPadding: const EdgeInsets.only(left: padding12),
                ),
                textInputAction: TextInputAction.search,
                onChanged: (text) => _onQueryChanged(text, typeToSearchEnabled),
                onSubmitted: _onQuerySubmitted,
              ),
            ),
            if (isActive)
              IconButton(
                focusNode: searchResetButtonFocus,
                focusColor: colors.secondaryContainer,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceContainerHigh,
                ),
                onPressed: clear,
                icon: const Icon(Icons.clear_rounded),
                color: colors.outline,
                tooltip: context.locale.home__search__reset,
              ),
            if (size.width > 300)
              FilterButton(onChange: onFilterChange, filterState: filterState),
            if (isMobilePlatform &&
                Breakpoints.isMobile(size.width) &&
                !isFocused)
              const AppLayoutToggleButton(rounded: true),
          ],
        ),
      ),
    );
  }
}
