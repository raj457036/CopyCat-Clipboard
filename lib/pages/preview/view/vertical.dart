import 'package:clipboard/pages/preview/view/clip_preview_config.dart';
import 'package:clipboard/pages/preview/widgets/clip_detail_form.dart';
import 'package:clipboard/pages/preview/widgets/preview.dart';
import 'package:clipboard/pages/preview/widgets/preview_options.dart';
import 'package:clipboard/base/db/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ClipItemPreviewVerticalView extends StatelessWidget {
  final ClipboardItem item;
  const ClipItemPreviewVerticalView({
    super.key,
    required this.item,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(context.locale.preview__vert_view__tab1_title),
      ),
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: context.locale.preview__vert_view__tab1_title),
                  Tab(text: context.locale.preview__vert_view__tab2__title),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipPreviewConfig(
                          shape: const RoundedRectangleBorder(),
                          child: ClipPreview(item: item),
                        ),
                        Positioned(
                          bottom: 20,
                          right: 0,
                          left: 0,
                          child: Center(
                            child: PreviewOptions(
                              item: item,
                              direction: Axis.vertical,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ClipDetailForm(item: item),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
