import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ExportE2eeDialog extends StatelessWidget {
  final bool loading;
  final Widget? bottom;
  final VoidCallback exportEnc2Key;

  const ExportE2eeDialog({
    super.key,
    required this.loading,
    required this.exportEnc2Key,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.lock),
          width12,
          Text(
            context.locale.dialog__e2e__title,
            style: textTheme.titleMedium?.copyWith(
              fontVariations: fontVarW700,
            ),
          ),
          width12,
          const Spacer(),
          const CloseButton(),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 420,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card.outlined(
              margin: EdgeInsets.zero,
              color: Colors.green.withValues(alpha: 0.2),
              child: ListTile(
                title: Text(
                  context.locale.dialog__text__e2e_key_export,
                  textAlign: TextAlign.center,
                ),
                titleTextStyle: textTheme.titleSmall,
                textColor: Colors.green,
              ),
            ),
            height12,
            Text(
              context.locale.dialog__text__e2e_key_export__note,
              textAlign: TextAlign.center,
            ),
            height10,
            ElevatedButton.icon(
              icon: const Icon(Icons.key),
              label: Text(context.locale.app__export),
              onPressed: loading ? null : exportEnc2Key,
            ),
            if (bottom != null) ...[
              const Divider(height: 30),
              bottom!,
            ]
          ],
        ),
      ),
    );
  }
}
