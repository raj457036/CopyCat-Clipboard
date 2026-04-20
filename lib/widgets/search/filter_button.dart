import 'package:clipboard/base/domain/model/search_filter_state.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/search/filter_dialog.dart';
import 'package:flutter/material.dart';

typedef OnFilterChangeCallback = void Function(SearchFilterState filterState);

class FilterButton extends StatelessWidget {
  final OnFilterChangeCallback onChange;
  final SearchFilterState filterState;

  const FilterButton({
    super.key,
    required this.filterState,
    required this.onChange,
  });

  Future<void> _openDialog(BuildContext context) async {
    final newState = await FilterDialog(state: filterState).open(context);
    if (newState == null) return;
    if (context.mounted) onChange(newState);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = filterState.isActive;
    final count = filterState.activeFilterCount;
    return Focus(
      skipTraversal: true,
      descendantsAreFocusable: false,
      child: Badge(
        isLabelVisible: count > 0,
        label: Text('$count'),
        backgroundColor: colors.error,
        textColor: colors.onError,
        child: IconButton(
          icon: const Icon(Icons.filter_list_rounded),
          iconSize: 20,
          tooltip: context.locale.search__tooltip__filter,
          color: active ? colors.onPrimary : null,
          style: IconButton.styleFrom(
            backgroundColor: active
                ? colors.primary
                : colors.surfaceContainerHighest,
          ),
          onPressed: () => _openDialog(context),
        ),
      ),
    );
  }
}
