import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultSortOrderTile extends StatelessWidget {
  const DefaultSortOrderTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    final locale = context.locale;
    return ListTile(
      title: Text(locale.settings__dropdown__default_sort_order__title),
      trailing: BlocSelector<AppConfigCubit, AppConfigState, SortOrder>(
        selector: (state) => state.config.sortOrder,
        builder: (context, sortOrder) {
          return SegmentedButton<SortOrder>(
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
                cubit.setSortConfig(sortOrder: val.first),
          );
        },
      ),
    );
  }
}
