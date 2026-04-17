import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultSortByDropdownTile extends StatelessWidget {
  const DefaultSortByDropdownTile({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AppConfigCubit>();
    final locale = context.locale;
    return ListTile(
      title: Text(locale.settings__dropdown__default_sort__title),
      contentPadding: const EdgeInsets.only(left: padding16, right: padding4),
      trailing: BlocSelector<AppConfigCubit, AppConfigState, ClipboardSortKey>(
        selector: (state) => state.config.sortBy,
        builder: (context, sortBy) {
          return DropdownButtonHideUnderline(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: DropdownButton<ClipboardSortKey>(
                isExpanded: true,
                value: sortBy,
                padding: const EdgeInsets.symmetric(horizontal: padding16),
                borderRadius: radius26,
                icon: const Icon(Icons.arrow_drop_down_rounded),
                items: [
                  DropdownMenuItem(
                    value: ClipboardSortKey.modified,
                    child: Text(locale.search_filter__sort_by__last_mod),
                  ),
                  DropdownMenuItem(
                    value: ClipboardSortKey.created,
                    child: Text(locale.search_filter__sort_by__created),
                  ),
                  DropdownMenuItem(
                    value: ClipboardSortKey.copyCount,
                    child: Text(locale.search_filter__sort_by__copy_count),
                  ),
                  DropdownMenuItem(
                    value: ClipboardSortKey.lastCopied,
                    child: Text(locale.search_filter__sort_by__last_copied),
                  ),
                ],
                onChanged: (val) => cubit.setSortConfig(sortBy: val),
              ),
            ),
          );
        },
      ),
    );
  }
}
