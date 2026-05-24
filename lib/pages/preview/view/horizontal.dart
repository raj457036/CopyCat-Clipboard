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
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(padding16),
              child: ClipPreviewConfig(
                shape: const RoundedRectangleBorder(borderRadius: radius8),
                child: ClipPreview(item: item),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: padding16,
                bottom: padding16,
                right: padding16,
              ),
              child: ClipInspector(
                item: item,
                includePagePadding: false,
                showHeader: false,
                currentDeviceId: sl<String>(instanceName: "device_id"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
