import 'package:android_background_clipboard/android_background_clipboard.dart'
    show AndroidBackgroundClipboard;
import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/numbers/file_sizes.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/di/di.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_io/io.dart';

class DontAutoCopyOverDropdown extends StatelessWidget {
  const DontAutoCopyOverDropdown({super.key});

  ({Widget leading, Widget child}) _itemDetails(
    BuildContext context,
    int value,
  ) {
    final (double size, String label) = switch (value) {
      $5MB => (5, context.locale.settings__text__5MB),
      $10MB => (10, context.locale.settings__text__10MB),
      $20MB => (15, context.locale.settings__text__20MB),
      $50MB => (20, context.locale.settings__text__50MB),
      $100MB => (24, context.locale.settings__text__100MB),
      _ => (10, formatBytes(value, precise: false)),
    };

    return (
      leading: SizedBox.square(
        dimension: 24,
        child: Icon(Icons.circle, size: size),
      ),
      child: Text(label),
    );
  }

  Future<void> _onSelected(BuildContext context, int value) async {
    final cubit = context.read<AppConfigCubit>();

    if (Platform.isAndroid) {
      await sl<AndroidBackgroundClipboard>().writeShared('dontCopyOver', value);
    }
    await cubit.changeDontCopyOver(value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, int>(
      selector: (state) {
        switch (state) {
          case AppConfigLoaded(:final config):
            return config.dontCopyOver.isNegative ? $10MB : config.dontCopyOver;
          default:
            return $10MB;
        }
      },
      builder: (context, state) {
        return ListTile(
          leading: const Icon(Icons.block_rounded),
          title: Text(
            context.locale.settings__dropdown__no_copy_over_limit__title,
          ),
          subtitle: Text(
            context.locale.settings__dropdown__no_copy_over_limit__subtitle(
              fileSize: formatBytes(state, precise: false),
            ),
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          trailing: SettingsMenuDropdown<int>(
            value: state,
            items: const [
              SettingsDropdownItem(value: $5MB),
              SettingsDropdownItem(value: $10MB),
              SettingsDropdownItem(value: $20MB),
              SettingsDropdownItem(value: $50MB),
              SettingsDropdownItem(value: $100MB),
            ],
            itemBuilder: (context, value) {
              final details = _itemDetails(context, value);
              return (
                leading: details.leading,
                child: details.child,
                trailing: null,
              );
            },
            onSelected: (value) => _onSelected(context, value),
          ),
        );
      },
    );
  }
}
