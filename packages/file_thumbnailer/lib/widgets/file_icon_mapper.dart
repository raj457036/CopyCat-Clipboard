import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;

class FileIconMapper {
  const FileIconMapper._();

  static IconData getIcon({
    String? mimeType,
    String? filePath,
  }) {
    final mime = mimeType?.toLowerCase();
    final ext = filePath != null ? p.extension(filePath).toLowerCase() : '';

    if (mime == 'application/pdf' || ext == '.pdf') {
      return Icons.picture_as_pdf_rounded;
    }

    if ((mime != null && mime.startsWith('image/')) ||
        const <String>{'.png', '.jpg', '.jpeg', '.webp', '.gif', '.bmp', '.svg'}
            .contains(ext)) {
      return Icons.image_rounded;
    }

    if ((mime != null && mime.startsWith('video/')) ||
        const <String>{'.mp4', '.mkv', '.mov', '.avi', '.webm'}.contains(ext)) {
      return Icons.video_file_rounded;
    }

    if ((mime != null && mime.startsWith('audio/')) ||
        const <String>{'.mp3', '.wav', '.ogg', '.m4a', '.flac', '.aac'}
            .contains(ext)) {
      return Icons.audio_file_rounded;
    }

    if (const <String>{
      '.zip',
      '.tar',
      '.gz',
      '.7z',
      '.rar',
      '.bz2',
      '.xz',
      '.iso'
    }.contains(ext) ||
        (mime != null &&
            (mime.contains('zip') ||
                mime.contains('archive') ||
                mime.contains('tar') ||
                mime.contains('compressed')))) {
      return Icons.folder_zip_rounded;
    }

    if (const <String>{
      '.dart',
      '.py',
      '.js',
      '.ts',
      '.jsx',
      '.tsx',
      '.html',
      '.css',
      '.json',
      '.xml',
      '.yaml',
      '.yml',
      '.c',
      '.cpp',
      '.h',
      '.java',
      '.kt',
      '.swift',
      '.go',
      '.rs',
      '.sh',
      '.sql'
    }.contains(ext)) {
      return Icons.code_rounded;
    }

    if (const <String>{'.xlsx', '.xls', '.csv', '.ods'}.contains(ext) ||
        (mime != null && (mime.contains('sheet') || mime.contains('excel')))) {
      return Icons.table_chart_rounded;
    }

    if (const <String>{'.pptx', '.ppt', '.odp'}.contains(ext) ||
        (mime != null &&
            (mime.contains('presentation') || mime.contains('powerpoint')))) {
      return Icons.slideshow_rounded;
    }

    if (const <String>{'.docx', '.doc', '.odt', '.rtf'}.contains(ext) ||
        (mime != null && (mime.contains('word') || mime.contains('document')))) {
      return Icons.description_rounded;
    }

    if (const <String>{'.txt', '.md', '.log'}.contains(ext) ||
        (mime != null && mime.startsWith('text/'))) {
      return Icons.article_rounded;
    }

    return Icons.insert_drive_file_rounded;
  }
}
