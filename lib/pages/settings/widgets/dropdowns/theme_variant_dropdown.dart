import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/widgets/subscription/subscription_provider.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeVariantDropdown extends StatelessWidget {
  const ThemeVariantDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    final cubit = context.read<AppConfigCubit>();

    return SubscriptionBuilder(builder: (context, subscription) {
      final hasAccess =
          subscription != null && subscription.isActive && subscription.theming;
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
          style: textTheme.bodyMedium?.copyWith(
            color: colors.outline,
          ),
        ),
        trailing:
            BlocSelector<AppConfigCubit, AppConfigState, DynamicSchemeVariant>(
          selector: (state) {
            return state.config.themeVariant;
          },
          builder: (context, variant) {
            return DropdownButtonHideUnderline(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 160),
                child: DropdownButton<DynamicSchemeVariant>(
                  value: variant,
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: padding16),
                  borderRadius: radius26,
                  items: [
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.tonalSpot,
                      child: Text(
                        context.locale.settings__color_mode__tonalSpot,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.content,
                      child: Text(
                        context.locale.settings__color_mode__content,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.expressive,
                      child: Text(
                        context.locale.settings__color_mode__expressive,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.fidelity,
                      child: Text(
                        context.locale.settings__color_mode__fidelity,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.fruitSalad,
                      child: Text(
                        context.locale.settings__color_mode__fruit_salad,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.monochrome,
                      child: Text(
                        context.locale.settings__color_mode__monochrome,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.neutral,
                      child: Text(
                        context.locale.settings__color_mode__neutral,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.rainbow,
                      child: Text(
                        context.locale.settings__color_mode__rainbow,
                      ),
                    ),
                    DropdownMenuItem(
                      value: DynamicSchemeVariant.vibrant,
                      child: Text(
                        context.locale.settings__color_mode__vibrant,
                      ),
                    ),
                  ],
                  onChanged: hasAccess ? cubit.setThemeColorVariant : null,
                ),
              ),
            );
          },
        ),
        contentPadding: const EdgeInsets.only(
          left: padding16,
          right: padding4,
        ),
      );
    });
  }
}
