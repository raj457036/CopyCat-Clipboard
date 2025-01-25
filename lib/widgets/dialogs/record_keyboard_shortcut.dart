import 'package:copycat_base/constants/font_variations.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:universal_io/io.dart';

class RecordKeyboardShortcutDialog extends StatefulWidget {
  const RecordKeyboardShortcutDialog({super.key});

  @override
  State<RecordKeyboardShortcutDialog> createState() =>
      _RecordKeyboardShortcutDialogState();

  Future<HotKey?> open(BuildContext context) async {
    return await showDialog<HotKey?>(
      context: context,
      builder: (context) => this,
    );
  }
}

class _RecordKeyboardShortcutDialogState
    extends State<RecordKeyboardShortcutDialog> {
  HotKey? hotKey;

  @override
  Widget build(BuildContext context) {
    final revert = Platform.isWindows;
    final options = [
      TextButton(
        onPressed: () => Navigator.pop(context, null),
        child: Text(context.mlocale.cancelButtonLabel.title),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, hotKey),
        autofocus: true,
        child: Text(context.mlocale.okButtonLabel),
      ),
    ];
    return SimpleDialog(
      title: Text(context.locale.dialog__record_keys__title),
      contentPadding: const EdgeInsets.all(padding16),
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: SizedBox(
            height: 50,
            child: Center(
              child: HotKeyRecorder(
                onHotKeyRecorded: (hotKey) {
                  final isEnter =
                      hotKey.logicalKey == LogicalKeyboardKey.enter ||
                          hotKey.logicalKey == LogicalKeyboardKey.numpadEnter;

                  if (isEnter) return;
                  setState(() {
                    this.hotKey = hotKey;
                  });
                },
              ),
            ),
          ),
        ),
        height12,
        Text.rich(
          TextSpan(
            text: context.locale.dialog__record_keys__subtitle,
            children: [
              TextSpan(
                text: context.locale.app__confirm,
                style: const TextStyle(
                  fontVariations: fontVarW700,
                ),
              )
            ],
          ),
          textAlign: TextAlign.center,
        ),
        height12,
        OverflowBar(
          children: revert ? options.reversed.toList() : options,
        )
      ],
    );
  }
}
