import 'package:copycat_base/constants/font_variations.dart';
import 'package:copycat_base/constants/widget_styles.dart';
import 'package:copycat_base/l10n/l10n.dart';
import 'package:copycat_base/utils/common_extension.dart';
import 'package:flutter/material.dart';

class GenerateE2eeDialog extends StatelessWidget {
  final bool loading;
  final VoidCallback generateEnc2Key;

  const GenerateE2eeDialog({
    super.key,
    required this.loading,
    required this.generateEnc2Key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AlertDialog(
      insetPadding: const EdgeInsets.all(padding10),
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
          if (!loading) const CloseButton(),
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
              color: const Color.fromARGB(255, 219, 215, 180).withAlpha(51),
              child: ListTile(
                title: Text(
                  context.locale.dialog__text__e2e_key_generate,
                  textAlign: TextAlign.center,
                ),
                titleTextStyle: textTheme.titleSmall,
                textColor: Colors.orange.shade800,
              ),
            ),
            height10,
            ElevatedButton.icon(
              onPressed: loading ? null : generateEnc2Key,
              icon: const Icon(Icons.key),
              label: loading
                  ? Text(context.locale.dialog__button__e2e_generating_key)
                  : Text(context.locale.dialog__button__e2e_generate_key),
            ),
          ],
        ),
      ),
    );
  }
}
