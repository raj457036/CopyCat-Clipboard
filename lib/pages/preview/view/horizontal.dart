import 'package:clipboard/di/di.dart';
import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/pages/preview/widgets/clip_inspector.dart';
import 'package:clipboard/pages/preview/widgets/preview.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ClipItemPreviewHorizontalView extends StatelessWidget {
  final ClipboardItem item;
  const ClipItemPreviewHorizontalView({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 11,
            child: Padding(
              padding: const EdgeInsets.all(padding16),
              child: ClipPreviewConfig(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(circleRadius12),
                ),
                child: ClipPreview(item: item),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: context.colors.outlineVariant),
                ),
              ),
              child: SingleChildScrollView(
                child: ClipInspector(
                  item: item,
                  showHeader: false,
                  currentDeviceId: sl<String>(instanceName: "device_id"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
