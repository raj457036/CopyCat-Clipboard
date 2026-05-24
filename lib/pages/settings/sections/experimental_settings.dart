import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/pages/settings/widgets/android_clipboard/setting_tile.dart';
import 'package:clipboard/pages/settings/widgets/drag_n_drop/drag_n_drop_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/auto_write_on_receive_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/lan_instant_sync_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/rich_data_capture_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/prevent_duplicate_switch.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';

class ExperimentalSettings extends StatelessWidget {
  const ExperimentalSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 650),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: padding12),
        children: [
          const DragAndDropSwitchTile(),
          if (isDesktopPlatform) const RichDataCaptureSwitchTile(),
          if (Platform.isAndroid) const AndroidClipboardSettingListTile(),
          if (isDesktopPlatform) const PreventDuplicateSwitchTile(),
          if (isDesktopPlatform) const LanInstantSyncSwitchTile(),
          if (isDesktopPlatform) const AutoWriteOnReceiveSwitchTile(),
        ],
      ),
    );
  }
}
