import 'package:clipboard/pages/settings/widgets/dropdowns/default_sort_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/default_sort_order_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/color_picker.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/theme_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/theme_variant_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/pages/settings/widgets/switches/clipboard_hotkey_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/smart_paste_switch.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class CustomizationSettings extends StatelessWidget {
  const CustomizationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: padding12),
        children: [
          SettingHeader(name: locale.settings__header__appearance),
          const ThemeDropdownTile(),
          const ColorPickerTile(),
          const ThemeVariantDropdown(),
          height24,
          SettingHeader(name: locale.settings__header__sorting),
          const DefaultSortByDropdownTile(),
          const DefaultSortOrderTile(),
          height24,
          SettingHeader(name: locale.settings__header__interactions),
          const SmartPasteSwitch(),
          const ClipboardHotKeySwitch(),
        ],
      ),
    );
  }
}
