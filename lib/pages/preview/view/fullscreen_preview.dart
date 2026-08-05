import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/pages/preview/widgets/preview.dart';
import 'package:flutter/material.dart';

class ClipPreviewFullscreenPage extends StatelessWidget {
  final ClipboardItem item;

  const ClipPreviewFullscreenPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: ClipPreviewConfig(child: ClipPreview(item: item)),
    );
  }
}
