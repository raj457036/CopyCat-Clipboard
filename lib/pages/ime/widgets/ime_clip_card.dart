import 'package:clipboard/base/constants/widget_styles.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/pages/ime/ime_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';

class ImeClipCard extends StatelessWidget {
  final ClipboardItem clip;
  final ImeService imeService;

  const ImeClipCard({super.key, required this.clip, required this.imeService});

  String get _displayLabel {
    if (clip.type == ClipItemType.text || clip.type == ClipItemType.url) {
      final raw = clip.text ?? clip.url ?? '';
      return raw.length > 80 ? '${raw.substring(0, 80)}…' : raw;
    }
    return clip.title ?? clip.fileName ?? clip.fileMimeType ?? 'File';
  }

  bool _canCommitContent() {
    final mime = clip.fileMimeType;
    if (mime == null) return false;
    return imeService.supportsContentType(mime);
  }

  Future<void> _onTap(BuildContext context) async {
    HapticFeedback.lightImpact();
    try {
      switch (clip.type) {
        case ClipItemType.text:
          await imeService.commitText(clip.text ?? '');
        case ClipItemType.url:
          await imeService.commitText(clip.url ?? clip.text ?? '');
        case ClipItemType.media:
        case ClipItemType.file:
          final path = clip.localPath;
          final mime = clip.fileMimeType ?? '*/*';
          if (path != null && _canCommitContent()) {
            await imeService.commitContent(
              filePath: path,
              mimeType: mime,
              label: clip.title ?? clip.fileName ?? 'File',
            );
          } else {
            final fallback = clip.text ?? clip.url ?? clip.fileName ?? '';
            await imeService.copyToClipboard(fallback, label: 'Clip');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Copied - Paste manually'),
                  duration: Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
      }
    } catch (_) {
      // Silently ignore: InputConnection may have become null
    }
  }

  @override
  Widget build(BuildContext context) {
    late Widget child;

    if (clip.fileMimeType?.startsWith("image/") == true) {
      child = Image.file(File(clip.localPath!), fit: BoxFit.cover);
    } else if (clip.isTextType) {
      child = Padding(
        padding: const EdgeInsets.all(padding10),
        child: Text(
          _displayLabel,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      );
    } else {
      return const Icon(Icons.file_present_rounded);
    }

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        borderRadius: radius12,
        onTap: () => _onTap(context),
        child: child,
      ),
    );
  }
}
