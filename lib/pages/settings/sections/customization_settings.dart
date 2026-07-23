import 'package:clipboard/pages/settings/widgets/dropdowns/default_sort_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/default_sort_order_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/clipboard_feedback_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/color_picker.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/theme_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/dropdowns/theme_variant_dropdown.dart';
import 'package:clipboard/pages/settings/widgets/setting_header.dart';
import 'package:clipboard/pages/settings/widgets/switches/clipboard_hotkey_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/focus_loss_behavior_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/paste_stack_hotkey_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/quick_paste_hotkey_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/smart_paste_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/transform_behavior_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/type_to_search_switch.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class CustomizationSettings extends StatelessWidget {
  const CustomizationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final dense = context.isMobile;
    return ListView(
      padding: dense
          ? const EdgeInsets.symmetric(vertical: padding12)
          : const EdgeInsets.all(padding12),
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
        if (isDesktopPlatform) const FocusLossBehaviorSwitch(),
        if (Platform.isMacOS || Platform.isWindows)
          const ClipboardFeedbackDropdownTile(),
        const TransformBehaviorSwitch(),
        const TypeToSearchSwitch(),
        height24,
        if (isDesktopPlatform) const SettingHeader(name: "Keyboard Shortcuts"),
        if (isDesktopPlatform) const ClipboardHotKeySwitch(),
        if (isDesktopPlatform) const PasteStackHotKeySwitch(),
        if (isDesktopPlatform) const QuickPasteHotKeySwitch(),
      ],
    );
  }
}
