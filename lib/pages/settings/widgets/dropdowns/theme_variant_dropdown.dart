import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/widgets/settings_menu_dropdown.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeVariantDropdown extends StatelessWidget {
  const ThemeVariantDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();

    return SubscriptionBuilder(
      builder: (context, subscription) {
        final hasAccess =
            subscription != null &&
            subscription.isActive &&
            subscription.theming;
        return ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(context.locale.settings__dropdown__color_mode__title),
              width8,
              const ProBadge(),
            ],
          ),
          subtitle: Text(
            context.locale.settings__dropdown__color_mode__subtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          trailing:
              BlocSelector<
                AppConfigCubit,
                AppConfigState,
                DynamicSchemeVariant
              >(
                selector: (state) {
                  return state.config.themeVariant;
                },
                builder: (context, variant) {
                  return SettingsMenuDropdown<DynamicSchemeVariant>(
                    value: variant,
                    maxWidth: 180,
                    items: const [
                      SettingsDropdownItem(
                        value: DynamicSchemeVariant.tonalSpot,
                      ),
                      SettingsDropdownItem(value: DynamicSchemeVariant.content),
                      SettingsDropdownItem(
                        value: DynamicSchemeVariant.expressive,
                      ),
                      SettingsDropdownItem(
                        value: DynamicSchemeVariant.fidelity,
                      ),
                      SettingsDropdownItem(
                        value: DynamicSchemeVariant.fruitSalad,
                      ),
                      SettingsDropdownItem(
                        value: DynamicSchemeVariant.monochrome,
                      ),
                      SettingsDropdownItem(value: DynamicSchemeVariant.neutral),
                      SettingsDropdownItem(value: DynamicSchemeVariant.rainbow),
                      SettingsDropdownItem(value: DynamicSchemeVariant.vibrant),
                    ],
                    itemBuilder: (context, value) {
                      final label = switch (value) {
                        DynamicSchemeVariant.tonalSpot =>
                          context.locale.settings__color_mode__tonalSpot,
                        DynamicSchemeVariant.content =>
                          context.locale.settings__color_mode__content,
                        DynamicSchemeVariant.expressive =>
                          context.locale.settings__color_mode__expressive,
                        DynamicSchemeVariant.fidelity =>
                          context.locale.settings__color_mode__fidelity,
                        DynamicSchemeVariant.fruitSalad =>
                          context.locale.settings__color_mode__fruit_salad,
                        DynamicSchemeVariant.monochrome =>
                          context.locale.settings__color_mode__monochrome,
                        DynamicSchemeVariant.neutral =>
                          context.locale.settings__color_mode__neutral,
                        DynamicSchemeVariant.rainbow =>
                          context.locale.settings__color_mode__rainbow,
                        DynamicSchemeVariant.vibrant =>
                          context.locale.settings__color_mode__vibrant,
                      };

                      return (
                        leading: null,
                        child: Text(label),
                        trailing: null,
                      );
                    },
                    onSelected: hasAccess ? cubit.setThemeColorVariant : null,
                  );
                },
              ),
        );
      },
    );
  }
}
