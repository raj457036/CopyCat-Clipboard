import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/dialogs/record_keyboard_shortcut.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

class QuickPasteHotKeySwitch extends StatelessWidget {
  const QuickPasteHotKeySwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return HasAccessToFeature(
      hasAccess: (subscription) =>
          subscription.isActive && !subscription.isFree,
      builder: (context, hasAccess, _) {
        return BlocSelector<AppConfigCubit, AppConfigState, HotKey?>(
          selector: (state) {
            return state.config.getQuickPasteHotkey;
          },
          builder: (context, state) {
            return SwitchListTile(
              secondary: const Icon(Icons.flash_on_rounded),
              title: ProBadge(
                child: Text(
                  context.locale.settings__switch__quickpaste_hotkey__title,
                ),
              ),
              isThreeLine: true,
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height4,
                  Text(
                    context
                        .locale
                        .settings__switch__quickpaste_hotkey__subtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colors.outline,
                    ),
                  ),
                  height6,
                  if (state == null || !hasAccess)
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
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: padding4,
                              ),
                              child: HotKeyVirtualView(hotKey: state),
                            ),
                            alignment: PlaceholderAlignment.middle,
                          ),
                          TextSpan(
                            text: context.locale.settings__hotkey__preview_end,
                          ),
                        ],
                        style: textTheme.bodySmall?.copyWith(
                          color: colors.outline,
                        ),
                      ),
                      maxLines: 2,
                    ),
                ],
              ),
              value: state != null && hasAccess,
              onChanged: hasAccess
                  ? (value) async {
                      final cubit = BlocProvider.of<AppConfigCubit>(context);

                      if (!value) {
                        await cubit.setQuickPasteHotkey(null);
                        return;
                      }

                      final hotKey = await const RecordKeyboardShortcutDialog()
                          .open(context);
                      if (hotKey != null) {
                        await cubit.setQuickPasteHotkey(hotKey);
                      }
                    }
                  : null,
            );
          },
        );
      },
    );
  }
}
