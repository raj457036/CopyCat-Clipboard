import 'package:clipboard/base/constants/font_variations.dart';
import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/data/services/e2ee_qr_transfer_service.dart';
import 'package:clipboard/base/l10n/l10n.dart';
import 'package:clipboard/utils/common_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrE2eeDialog extends StatefulWidget {
  const ScanQrE2eeDialog({super.key});

  @override
  State<ScanQrE2eeDialog> createState() => _ScanQrE2eeDialogState();
}

class _ScanQrE2eeDialogState extends State<ScanQrE2eeDialog> {
  final MobileScannerController controller = MobileScannerController();
  late final Future<bool> _hasCameraFuture = E2EEQrTransferService.hasCamera();
  bool consumed = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (consumed || !mounted) return;
    final value = capture.barcodes
        .map((barcode) => barcode.rawValue)
        .whereType<String>()
        .firstWhere((raw) => raw.trim().isNotEmpty, orElse: () => '');

    if (value.isEmpty) return;
    consumed = true;
    context.pop<String>(value);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return FutureBuilder<bool>(
      future: _hasCameraFuture,
      builder: (context, snapshot) {
        final hasCamera = snapshot.data == true;
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.qr_code_scanner),
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
                if (snapshot.connectionState != ConnectionState.done)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: CircularProgressIndicator(),
                  )
                else if (!hasCamera)
                  Text(
                    context
                        .locale
                        .transfer__device_has_no_camera_use_file_import,
                    textAlign: TextAlign.center,
                  )
                else ...[
                  Text(
                    context.locale.transfer__scan_qr_from_other_device,
                    textAlign: TextAlign.center,
                  ),
                  height12,
                  SizedBox.square(
                    dimension: 300,
                    child: ClipRRect(
                      borderRadius: radius12,
                      child: MobileScanner(
                        controller: controller,
                        onDetect: _onDetect,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
