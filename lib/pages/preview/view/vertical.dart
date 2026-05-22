import 'package:clipboard/di/di.dart' show sl;
import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/pages/preview/widgets/clip_inspector.dart';
import 'package:clipboard/pages/preview/widgets/preview.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ClipItemPreviewVerticalView extends StatelessWidget {
  final ClipboardItem item;
  const ClipItemPreviewVerticalView({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: context.isMobile || context.isTablet,
        centerTitle: false,
        title: Text(
          item.displayTitle ?? context.locale.preview__inspector__title,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 280, maxHeight: 360),
              child: ClipPreviewConfig(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: ClipPreview(item: item),
              ),
            ),
            const SizedBox(height: 16),
            ClipInspector(
              item: item,
              includePagePadding: false,
              showHeader: false,
              currentDeviceId: sl<String>(instanceName: "device_id"),
            ),
          ],
        ),
      ),
    );
  }
}
