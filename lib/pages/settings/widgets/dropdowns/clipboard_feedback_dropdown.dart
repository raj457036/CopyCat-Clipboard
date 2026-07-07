import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClipboardFeedbackDropdownTile extends StatelessWidget {
  const ClipboardFeedbackDropdownTile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();

    return ListTile(
      leading: const Icon(Icons.notifications),
      title: Text(context.locale.settings__dropdown__clipboard_feedback__title),
      subtitle: Text(
        context.locale.settings__dropdown__clipboard_feedback__subtitle,
        style: textTheme.bodyMedium?.copyWith(color: colors.outline),
      ),
      trailing:
          BlocSelector<AppConfigCubit, AppConfigState, ClipboardFeedbackMode>(
            selector: (state) => state.config.clipboardFeedbackMode,
            builder: (context, mode) {
              return SettingsMenuDropdown<ClipboardFeedbackMode>(
                value: mode,
                items: const [
                  SettingsDropdownItem(value: ClipboardFeedbackMode.disabled),
                  SettingsDropdownItem(value: ClipboardFeedbackMode.toast),
                  SettingsDropdownItem(value: ClipboardFeedbackMode.haptic),
                  SettingsDropdownItem(value: ClipboardFeedbackMode.both),
                ],
                itemBuilder: (context, value) {
                  final label = switch (value) {
                    ClipboardFeedbackMode.disabled =>
                      context.locale.settings__clipboard_feedback__disabled,
                    ClipboardFeedbackMode.toast =>
                      context.locale.settings__clipboard_feedback__toast,
                    ClipboardFeedbackMode.haptic =>
                      context.locale.settings__clipboard_feedback__haptic,
                    ClipboardFeedbackMode.both =>
                      context.locale.settings__clipboard_feedback__both,
                  };

                  return (leading: null, child: Text(label), trailing: null);
                },
                onSelected: cubit.setClipboardFeedbackMode,
              );
            },
          ),
    );
  }
}
