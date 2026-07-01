import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrTransferE2eeDialog extends StatefulWidget {
  final String payload;
  final String passcode;

  const QrTransferE2eeDialog({
    super.key,
    required this.payload,
    required this.passcode,
  });

  @override
  State<QrTransferE2eeDialog> createState() => _QrTransferE2eeDialogState();
}

class _QrTransferE2eeDialogState extends State<QrTransferE2eeDialog> {
  bool showPasscode = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.qr_code_2),
          width12,
          Expanded(
            child: Text(
              context.locale.dialog__e2e__title,
              style: textTheme.titleMedium?.copyWith(
                fontVariations: fontVarW700,
              ),
            ),
          ),
          const CloseButton(),
        ],
      ),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!showPasscode) ...[
              Text(
                context.locale.transfer__scan_qr_and_enter_passcode,
                textAlign: TextAlign.center,
              ),
              height12,
              Card(
                shape: const RoundedRectangleBorder(borderRadius: radius16),
                child: Padding(
                  padding: const EdgeInsets.all(padding8),
                  child: ClipRRect(
                    borderRadius: radius12,
                    child: SizedBox.square(
                      dimension: 240,
                      child: QrImageView(
                        backgroundColor: Colors.white,
                        data: widget.payload,
                        eyeStyle: const QrEyeStyle(
                          eyeShape: QrEyeShape.circle,
                          color: Colors.black,
                        ),
                        size: 240,
                        dataModuleStyle: const QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.circle,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              height12,
              OutlinedButton.icon(
                onPressed: () => setState(() => showPasscode = true),
                icon: const Icon(Icons.password),
                label: const Text('Show Passcode'),
              ),
            ] else ...[
              Text(
                context.locale.transfer__enter_passcode_on_other_device,
                textAlign: TextAlign.center,
              ),
              height12,
              Card.outlined(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  child: Text(
                    widget.passcode,
                    style: textTheme.headlineMedium?.copyWith(
                      fontVariations: fontVarW700,
                      letterSpacing: 6,
                    ),
                  ),
                ),
              ),
              height12,
              OutlinedButton.icon(
                onPressed: () => setState(() => showPasscode = false),
                icon: const Icon(Icons.qr_code_2),
                label: Text(context.locale.transfer__show_qr),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
