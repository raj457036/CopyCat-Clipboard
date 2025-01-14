import 'package:clipboard/widgets/search/filter_dialog.dart';
import 'package:copycat_base/domain/model/search_filter_state.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';

typedef OnFilterChangeCallback = void Function(SearchFilterState filterState);

class FilterButton extends StatelessWidget {
  final OnFilterChangeCallback onChange;
  final SearchFilterState initialState;

  const FilterButton({
    super.key,
    required this.initialState,
    required this.onChange,
  });

  Future<void> changeFilter(
    BuildContext context,
    SearchFilterState state,
  ) async {
    final newState = await FilterDialog(state: state).open(context);
    if (newState == null) return;
    if (context.mounted) {
      onChange(newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = initialState.isActive;
    return Focus(
      skipTraversal: true,
      descendantsAreFocusable: false,
      child: IconButton(
        icon: const Icon(Icons.filter_alt_rounded),
        iconSize: 20,
        tooltip: context.locale.search__tooltip__filter,
        color: active ? colors.secondaryContainer : null,
        style: IconButton.styleFrom(
          backgroundColor:
              active ? colors.primary : colors.surfaceContainerHighest,
        ),
        onPressed: () => changeFilter(context, initialState),
      ),
    );
  }
}
