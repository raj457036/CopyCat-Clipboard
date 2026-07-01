import 'package:clipboard/base/data/services/e2ee_qr_transfer_service.dart';
import 'package:flutter/material.dart';

class E2EEQrScanActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String label;

  const E2EEQrScanActionButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  State<E2EEQrScanActionButton> createState() => _E2EEQrScanActionButtonState();
}

class _E2EEQrScanActionButtonState extends State<E2EEQrScanActionButton> {
  late final Future<bool> _hasCameraFuture = E2EEQrTransferService.hasCamera();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasCameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.shrink();
        }

        if (snapshot.data != true) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: OutlinedButton.icon(
            onPressed: widget.onPressed,
            icon: const Icon(Icons.qr_code_scanner),
            label: Text(widget.label),
          ),
        );
      },
    );
  }
}
