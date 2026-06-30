import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/pages/settings/widgets/drag_n_drop/drag_n_drop_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/auto_write_on_receive_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/lan_instant_sync_switch.dart';
import 'package:clipboard/pages/settings/widgets/switches/rich_data_capture_switch.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter/material.dart';

class ExperimentalSettings extends StatelessWidget {
  const ExperimentalSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final dense = context.isMobile;
    return ListView(
      padding: dense
          ? const EdgeInsets.symmetric(vertical: padding12)
          : const EdgeInsets.all(padding12),
      children: [
        const DragAndDropSwitchTile(),
        if (isDesktopPlatform) const RichDataCaptureSwitchTile(),
        if (isDesktopPlatform) const LanInstantSyncSwitchTile(),
        if (isDesktopPlatform) const AutoWriteOnReceiveSwitchTile(),
      ],
    );
  }
}
