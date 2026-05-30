import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/bloc/clipboard_cubit/clipboard_cubit.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultSortByDropdownTile extends StatelessWidget {
  const DefaultSortByDropdownTile({super.key});

  void _onSortByChanged(BuildContext context, ClipboardSortKey sortBy) {
    final appConfigCubit = context.read<AppConfigCubit>();
    final clipboardCubit = context.read<ClipboardCubit>();

    appConfigCubit.setSortConfig(sortBy: sortBy);
    clipboardCubit.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return ListTile(
      leading: const Icon(Icons.sort_by_alpha_rounded),
      title: Text(locale.settings__dropdown__default_sort__title),
      trailing: BlocSelector<AppConfigCubit, AppConfigState, ClipboardSortKey>(
        selector: (state) => state.config.sortBy,
        builder: (context, sortBy) {
          return SettingsMenuDropdown<ClipboardSortKey>(
            value: sortBy,
            maxWidth: 180,
            items: const [
              SettingsDropdownItem(value: ClipboardSortKey.modified),
              SettingsDropdownItem(value: ClipboardSortKey.created),
              SettingsDropdownItem(value: ClipboardSortKey.copyCount),
              SettingsDropdownItem(value: ClipboardSortKey.lastCopied),
            ],
            itemBuilder: (context, value) {
              final label = switch (value) {
                ClipboardSortKey.modified =>
                  locale.search_filter__sort_by__last_mod,
                ClipboardSortKey.created =>
                  locale.search_filter__sort_by__created,
                ClipboardSortKey.copyCount =>
                  locale.search_filter__sort_by__copy_count,
                ClipboardSortKey.lastCopied =>
                  locale.search_filter__sort_by__last_copied,
              };

              return (leading: null, child: Text(label), trailing: null);
            },
            onSelected: (value) => _onSortByChanged(context, value),
          );
        },
      ),
    );
  }
}
