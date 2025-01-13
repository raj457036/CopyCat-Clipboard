import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';

class ImportE2eeDialog extends StatelessWidget {
  final bool loading;
  final VoidCallback importEnc2Key;
  final bool invalidImportedKey;
  final Widget? bottom;

  const ImportE2eeDialog({
    super.key,
    required this.loading,
    required this.importEnc2Key,
    this.bottom,
    this.invalidImportedKey = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AlertDialog(
      // insetPadding: const EdgeInsets.all(padding10),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Icon(Icons.lock),
          width12,
          Text(
            context.locale.dialog__e2e__title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
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
            if (invalidImportedKey)
              Card.outlined(
                margin: EdgeInsets.zero,
                color: Colors.deepOrange.withAlpha(51),
                child: ListTile(
                  title: Text(
                    context.locale.dialog__text__invalid_e2e_key,
                    textAlign: TextAlign.center,
                  ),
                  titleTextStyle: textTheme.titleSmall,
                  textColor: Colors.deepOrange.shade800,
                ),
              ),
            if (invalidImportedKey) height12,
            Text(
              context.locale.dialog__text__e2e_key_import__note,
              textAlign: TextAlign.center,
            ),
            height10,
            ElevatedButton.icon(
              onPressed: loading ? null : importEnc2Key,
              icon: const Icon(Icons.key),
              label: loading
                  ? Text(context.locale.dialog__button__e2e_importing_key)
                  : Text(context.locale.dialog__button__e2e_import_key),
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
