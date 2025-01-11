import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/search/filter_button.dart';
import 'package:clipboard/widgets/view_buttons/app_layout_button.dart';
import 'package:copycat_base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:copycat_base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:copycat_base/constants/numbers/breakpoints.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/domain/model/search_filter_state.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:copycat_base/widgets/on_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchInputBar extends StatefulWidget {
  const SearchInputBar({super.key});

  @override
  State<SearchInputBar> createState() => _SearchBarInputState();
}

class _SearchBarInputState extends State<SearchInputBar> {
  SearchFilterState? filterState;
  late final TextEditingController queryController;
  late final FocusNode focusNode, searchResetButtonFocus;
  bool isFocused = false;

  void onFocus() {
    setState(() {
      isFocused = focusNode.hasFocus;
    });
  }

  @override
  void initState() {
    super.initState();
    queryController = TextEditingController();
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
    focusNode.removeListener(onFocus);
    queryController.dispose();
    focusNode.dispose();
    searchResetButtonFocus.dispose();
    super.dispose();
  }

  bool get isActive =>
      queryController.text != "" ||
      (filterState != null && filterState!.isActive);

  void focus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  void onSearchFocusEvent(BuildContext context, EventBusKeyboardEvent event) {
    if (event.event.name == "search") focus();
  }

  Future<void> search(String text) async {
    await context.read<ClipboardCubit>().fetch(
          query: text,
          fromTop: true,
        );
    setState(() {});
  }

  void onFilterChange(SearchFilterState? filterState) {
    setState(() {
      this.filterState = filterState;
    });
    final searchCubit = context.read<ClipboardCubit>();
    searchCubit.fetch(
      query: queryController.text,
      filterState: filterState,
      fromTop: true,
    );
  }

  void clear() {
    setState(() {
      queryController.clear();
      filterState = const SearchFilterState();
    });
    onFilterChange(null);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final size = context.mq.size;
    return OnEvent<EventBusKeyboardEvent>(
      trigger: onSearchFocusEvent,
      child: AnimatedContainer(
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(50),
                    ),
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
                  hintText: context.locale.searchInClipboard,
                  contentPadding: const EdgeInsets.only(left: padding12),
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: search,
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
                tooltip: context.locale.resetSearch,
              ),
            if (size.width > 300)
              FilterButton(
                onChange: onFilterChange,
                initialState: filterState ?? const SearchFilterState(),
              ),
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
