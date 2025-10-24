import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/base/widgets/subscription/subscription_provider.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color selectedColor;
  const ColorPickerDialog({
    super.key,
    required this.selectedColor,
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();

  Future<Color?> open(BuildContext context) async {
    final result = await showDialog<Color?>(
      context: context,
      builder: (context) => this,
    );

    if (result != null) return result;
    return null;
  }
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color? color_;

  void onChangeColor(Color color) {
    color_ = color;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actionsPadding: const EdgeInsets.only(
        bottom: padding12,
      ),
      // titlePadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: ColorPicker(
          portraitOnly: true,
          pickerColor: widget.selectedColor,
          onColorChanged: onChangeColor,
          pickerAreaBorderRadius: const BorderRadius.vertical(
            top: Radius.circular(16),
          ),
          displayThumbColor: false,
          paletteType: PaletteType.hsl,
          hexInputBar: false,
          enableAlpha: false,
          colorPickerWidth: 282,
          pickerAreaHeightPercent: 0.6,
          labelTypes: const [],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(context.mlocale.cancelButtonLabel.title),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, color_);
          },
          child: Text(context.locale.app__select),
        ),
      ],
      contentPadding: EdgeInsets.zero,
    );
  }
}

class ColorPickerTile extends StatelessWidget {
  const ColorPickerTile({super.key});

  Future<void> chooseColor(BuildContext context, Color color) async {
    final cubit = context.read<AppConfigCubit>();
    final result = await ColorPickerDialog(
      selectedColor: color,
    ).open(context);

    if (result != null) {
      cubit.setThemeColor(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return SubscriptionBuilder(builder: (context, subscription) {
      final hasAccess =
          subscription != null && subscription.isActive && subscription.theming;
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(context.locale.settings__tile__theme_color__title),
            width8,
            const ProBadge(),
          ],
        ),
        contentPadding: const EdgeInsets.only(
          left: padding16,
          right: padding4,
        ),
        subtitle: Text(
          context.locale.settings__tile__theme_color__subtitle,
          style: textTheme.bodyMedium?.copyWith(
            color: colors.outline,
          ),
        ),
        trailing: BlocSelector<AppConfigCubit, AppConfigState, int>(
          selector: (state) {
            return state.config.themeColor;
          },
          builder: (context, themeColor) {
            final color = Color(
              themeColor.isNegative ? defaultThemeColor : themeColor,
            );
            return FilledButton.icon(
              onPressed: hasAccess ? () => chooseColor(context, color) : null,
              label: Text(context.locale.app__change),
              icon: const Icon(Icons.color_lens_rounded),
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(150, 46),
                textStyle: textTheme.titleMedium,
              ),
            );
          },
        ),
      );
    });
  }
}
