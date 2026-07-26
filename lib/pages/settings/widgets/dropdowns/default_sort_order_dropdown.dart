import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultSortOrderTile extends StatelessWidget {
  const DefaultSortOrderTile({super.key});

  void _onSortOrderChanged(BuildContext context, SortOrder sortOrder) {
    final appConfigCubit = context.read<AppConfigCubit>();
    final clipboardCubit = context.read<ClipboardCubit>();

    appConfigCubit.setSortConfig(sortOrder: sortOrder);
    clipboardCubit.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return ListTile(
      leading: const Icon(Icons.sort_rounded),
      title: Text(locale.settings__dropdown__default_sort_order__title),
      trailing: BlocSelector<AppConfigCubit, AppConfigState, SortOrder>(
        selector: (state) => state.config.sortOrder,
        builder: (context, sortOrder) {
          return SegmentedButton<SortOrder>(
            style: SegmentedButton.styleFrom(
              enabledMouseCursor: SystemMouseCursors.click,
            ),
            segments: [
              ButtonSegment(
                value: SortOrder.asc,
                label: Text(locale.search_filter__sort_ord__asc),
              ),
              ButtonSegment(
                value: SortOrder.desc,
                label: Text(locale.search_filter__sort_ord__desc),
              ),
            ],
            selected: {sortOrder},
            onSelectionChanged: (val) =>
                _onSortOrderChanged(context, val.first),
          );
        },
      ),
    );
  }
}
