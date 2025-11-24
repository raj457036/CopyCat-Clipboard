import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/pages/preview/widgets/clip_detail_form.dart';
import 'package:clipboard/pages/preview/widgets/preview.dart';
import 'package:clipboard/pages/preview/widgets/preview_options.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:flutter/material.dart';

class ClipItemPreviewHorizontalView extends StatelessWidget {
  final ClipboardItem item;
  const ClipItemPreviewHorizontalView({
    super.key,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ClipPreviewConfig(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: circleRadius12,
                          bottomLeft: circleRadius12,
                        ),
                      ),
                      child: ClipPreview(item: item),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Center(
                      child: PreviewOptions(
                        item: item,
                        direction: Axis.horizontal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ClipDetailForm(item: item),
          ),
        ],
      ),
    );
  }
}
