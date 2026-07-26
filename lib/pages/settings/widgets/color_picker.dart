import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/widgets/badges.dart';
import 'package:clipboard/widgets/subscription/subscription_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color selectedColor;
  const ColorPickerDialog({super.key, required this.selectedColor});

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
      actionsPadding: const EdgeInsets.only(bottom: padding12),
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
    final result = await ColorPickerDialog(selectedColor: color).open(context);

    if (result != null) {
      cubit.setThemeColor(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colors = context.colors;
    return HasAccessToFeature(
      hasAccess: (subscription) =>
          subscription.isActive && subscription.theming,
      builder: (context, hasAccess, _) {
        return ListTile(
          leading: const Icon(Icons.color_lens_rounded),
          title: ProBadge(
            child: Text(context.locale.settings__tile__theme_color__title),
          ),
          subtitle: Text(
            context.locale.settings__tile__theme_color__subtitle,
            style: textTheme.bodyMedium?.copyWith(color: colors.outline),
          ),
          trailing: BlocSelector<AppConfigCubit, AppConfigState, int>(
            selector: (state) {
              return state.config.themeColor;
            },
            builder: (context, themeColor) {
              final color = Color(
                themeColor.isNegative ? defaultThemeColor : themeColor,
              );
              return ElevatedButton(
                onPressed: hasAccess ? () => chooseColor(context, color) : null,
                style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(
                    side: BorderSide(color: color, width: 2.0),
                  ),
                  backgroundColor: colors.surfaceContainerHigh,
                  foregroundColor: colors.primary,
                ),
                child: Text(context.locale.app__change),
              );
            },
          ),
        );
      },
    );
  }
}
