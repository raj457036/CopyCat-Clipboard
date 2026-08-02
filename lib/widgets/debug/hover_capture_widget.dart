import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:clipboard/widgets/yarn_ball_loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';

class HoverCaptureWidget extends StatefulWidget {
  final Widget child;
  final double pixelRatio;
  final bool saveToFile;
  final String fileNamePrefix;
  final Alignment buttonAlignment;
  final EdgeInsets buttonPadding;
  final ValueChanged<Uint8List>? onCaptured;

  const HoverCaptureWidget({
    super.key,
    required this.child,
    this.pixelRatio = 2.5,
    this.saveToFile = true,
    this.fileNamePrefix = 'widget_capture',
    this.buttonAlignment = Alignment.topRight,
    this.buttonPadding = const EdgeInsets.all(8),
    this.onCaptured,
  });

  @override
  State<HoverCaptureWidget> createState() => _HoverCaptureWidgetState();
}

class _HoverCaptureWidgetState extends State<HoverCaptureWidget> {
  final GlobalKey _captureKey = GlobalKey();
  bool _hovered = false;
  bool _capturing = false;

  Future<void> _capture() async {
    if (_capturing) return;

    setState(() => _capturing = true);

    try {
      await WidgetsBinding.instance.endOfFrame;

      final boundary =
          _captureKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;

      final image = await boundary.toImage(pixelRatio: widget.pixelRatio);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final bytes = byteData.buffer.asUint8List();
      widget.onCaptured?.call(bytes);

      if (!widget.saveToFile) return;

      final filePath = await FilePicker.saveFile(
        dialogTitle: 'Save captured widget',
        type: FileType.image,
        fileName: '${widget.fileNamePrefix}_${const Uuid().v4()}.png',
        bytes: bytes,
      );

      if (filePath == null) return;
      await File(filePath).writeAsBytes(bytes);

      if (!mounted) return;
      ScaffoldMessenger.maybeOf(
        context,
      )?.showSnackBar(const SnackBar(content: Text('Widget capture saved')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        const SnackBar(content: Text('Failed to capture widget')),
      );
    } finally {
      if (mounted) {
        setState(() => _capturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          RepaintBoundary(key: _captureKey, child: widget.child),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: !_hovered,
              child: Align(
                alignment: widget.buttonAlignment,
                child: Padding(
                  padding: widget.buttonPadding,
                  child: AnimatedOpacity(
                    opacity: _hovered ? 1 : 0,
                    duration: const Duration(milliseconds: 120),
                    child: Material(
                      color: Colors.black87,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Capture widget',
                        visualDensity: VisualDensity.compact,
                        onPressed: _capturing ? null : _capture,
                        icon: _capturing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: YarnBallLoading(),
                              )
                            : const Icon(
                                Icons.photo_camera,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
