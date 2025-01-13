import 'package:clipboard/widgets/dialogs/record_keyboard_shortcut.dart';
import 'package:copycat_base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:copycat_base/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class ClipboardHotKeySwitch extends StatelessWidget {
  const ClipboardHotKeySwitch({super.key});

  @override
  Widget build(BuildContext context) {
    if (isMobilePlatform) return const SizedBox.shrink();
    final textTheme = context.textTheme;
    final colors = context.colors;
    return BlocSelector<AppConfigCubit, AppConfigState, HotKey?>(
      selector: (state) {
        return state.config.getToggleHotkey;
      },
      builder: (context, state) {
        return SwitchListTile(
          title: Text(context.locale.settings__switch__hotkey__title),
          subtitle: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height4,
              Text(
                context.locale.settings__switch__hotkey__subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.outline,
                ),
              ),
              height6,
              if (state == null)
                Text(
                  context.locale.settings__hotkey__unassigned,
                  style: textTheme.bodySmall?.copyWith(
                    color: colors.outline,
                  ),
                )
              else
                RichText(
                  text: TextSpan(
                    text: context.locale.settings__hotkey__preview_start,
                    children: [
                      WidgetSpan(child: HotKeyVirtualView(hotKey: state)),
                      TextSpan(
                          text: context.locale.settings__hotkey__preview_end)
                    ],
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.outline,
                    ),
                  ),
                  maxLines: 2,
                ),
            ],
          ),
          value: state != null,
          onChanged: (value) async {
            final cubit = BlocProvider.of<AppConfigCubit>(context);

            if (!value) {
              await cubit.setClipboardToggleHotkey(null);
              return;
            }

            final hotKey =
                await const RecordKeyboardShortcutDialog().open(context);
            if (hotKey != null) {
              await cubit.setClipboardToggleHotkey(hotKey);
            }
          },
        );
      },
    );
  }
}
