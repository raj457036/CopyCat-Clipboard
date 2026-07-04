import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompactSearchBarInput extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String> onSubmit;

  const CompactSearchBarInput({
    super.key,
    required this.controller,
    this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Padding(
        padding: const EdgeInsets.only(left: padding8),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmit,
          decoration: InputDecoration(
            hintText: context.locale.app__search,
            border: const OutlineInputBorder(
              borderRadius: radius26,
              borderSide: BorderSide.none,
            ),
            fillColor: context.colors.secondaryContainer,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            constraints: const BoxConstraints(maxHeight: 32),
          ),
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }
}

class CompactSearchBar extends StatefulWidget {
  final Widget child;
  const CompactSearchBar({super.key, required this.child});

  @override
  State<CompactSearchBar> createState() => _CompactSearchBarState();
}

class _CompactSearchBarState extends State<CompactSearchBar> {
  late final TextEditingController _controller;
  bool _searchActive = false;
  final _debouncer = Debouncer(milliseconds: 300);

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _searchActive = !_searchActive;

      if (!_searchActive) {
        _controller.clear();
        context.read<ClipboardCubit>().resetFilters();
      }
    });
  }

  void _onSearchChanged(String value) {
    _debouncer(() {
      if (mounted) context.read<ClipboardCubit>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final typeToSearch = context.select(
      (AppConfigCubit cubit) => cubit.state.config.enableTypeToSearch,
    );
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          width8,
          TextButton.icon(
            icon: _searchActive
                ? const Icon(Icons.close_rounded)
                : const Icon(Icons.search_rounded),
            onPressed: _toggleSearch,
            style: TextButton.styleFrom(
              foregroundColor: context.colors.onSecondaryContainer,
              backgroundColor: context.colors.secondaryContainer,
              shape: const StadiumBorder(),
              enabledMouseCursor: SystemMouseCursors.click,
              disabledMouseCursor: SystemMouseCursors.forbidden,
            ),
            label: _searchActive
                ? Text(context.mlocale.closeButtonLabel)
                : Text(context.locale.app__search),
          ),
          Expanded(
            child: AnimatedCrossFade(
              firstChild: widget.child,
              secondChild: CompactSearchBarInput(
                controller: _controller,
                onChanged: typeToSearch ? _onSearchChanged : null,
                onSubmit: _onSearchChanged,
              ),
              crossFadeState: _searchActive
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}
