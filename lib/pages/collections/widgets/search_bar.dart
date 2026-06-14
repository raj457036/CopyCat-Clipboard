import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/event_bus_cubit/event_bus_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard/widgets/copycat_logo.dart';
import 'package:clipboard/widgets/on_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CollectionsSearchBar extends StatefulWidget {
  final ValueChanged<String> onQueryChanged;

  const CollectionsSearchBar({super.key, required this.onQueryChanged});

  @override
  State<CollectionsSearchBar> createState() => _CollectionsSearchBarState();
}

class _CollectionsSearchBarState extends State<CollectionsSearchBar> {
  late final TextEditingController _controller;
  late final FocusNode searchInputFocusNode;

  final Debouncer _debouncer = Debouncer(milliseconds: 250);
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    searchInputFocusNode = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape ||
            event.logicalKey == LogicalKeyboardKey.arrowDown) {
          node.focusInDirection(TraversalDirection.down);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      debugLabel: 'collections-search-input',
    );
    searchInputFocusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _debouncer.cancel();
    searchInputFocusNode.removeListener(_handleFocusChange);
    searchInputFocusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    if (!mounted) return;
    setState(() {
      _isFocused = searchInputFocusNode.hasFocus;
    });
  }

  void _focus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      searchInputFocusNode.requestFocus();
    });
  }

  void _onSearchFocusEvent(BuildContext context, EventBusKeyboardEvent event) {
    if (event.event.name != 'search') return;
    _focus();
  }

  void _emitQuery(String text) {
    widget.onQueryChanged(text.trim().toLowerCase());
  }

  void _onQueryChanged(String text, bool typeToSearchEnabled) {
    setState(() {});
    if (!typeToSearchEnabled) {
      _debouncer.cancel();
      return;
    }

    _debouncer(() {
      if (!mounted) return;
      _emitQuery(_controller.text);
    });
  }

  void _onQuerySubmitted(String text) {
    _debouncer.cancel();
    _emitQuery(text);
  }

  void _clearQuery() {
    if (_controller.text.isEmpty) return;
    _debouncer.cancel();
    _controller.clear();
    _emitQuery('');
    searchInputFocusNode.requestFocus();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final textTheme = context.textTheme;
    final hasQuery = _controller.text.isNotEmpty;
    final typeToSearchEnabled = context.select(
      (AppConfigCubit c) => c.state.config.enableTypeToSearch,
    );

    return OnEvent<EventBusKeyboardEvent>(
      trigger: _onSearchFocusEvent,
      child: AnimatedContainer(
        curve: Curves.easeIn,
        width: _isFocused ? 850 : 650,
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
                onFocusChange: (value) => value ? _focus() : null,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: SearchBar(
                    controller: _controller,
                    focusNode: searchInputFocusNode,
                    side: _isFocused
                        ? BorderSide(color: colors.outline, width: 2).wsp
                        : null,
                    smartDashesType: SmartDashesType.disabled,
                    smartQuotesType: SmartQuotesType.disabled,
                    onTapOutside: (_) => searchInputFocusNode.focusInDirection(
                      TraversalDirection.down,
                    ),
                    elevation: 0.0.wsp,
                    hintText: context.locale.collections__search__hint,
                    leading: const Align(
                      alignment: Alignment.bottomLeft,
                      child: CopyCatLogo(),
                    ),
                    backgroundColor: colors.surfaceContainerHigh.wsp,
                    trailing: [
                      if (isDesktopPlatform)
                        Align(
                          widthFactor: 1,
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(right: padding10),
                            child: Text(
                              keyboardShortcut(key: 'F'),
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
            if (hasQuery)
              IconButton(
                focusColor: colors.secondaryContainer,
                style: IconButton.styleFrom(
                  backgroundColor: colors.surfaceContainerHigh,
                  maximumSize: const Size.square(kToolbarHeight),
                  padding: const EdgeInsets.all(padding10),
                ),
                onPressed: _clearQuery,
                icon: const Icon(Icons.clear_rounded),
                color: colors.outline,
                tooltip: context.locale.home__search__reset,
              ),
          ],
        ),
      ),
    );
  }
}
