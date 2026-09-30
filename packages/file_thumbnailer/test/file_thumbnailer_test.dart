import 'package:file_thumbnailer/file_thumbnailer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ThumbnailRequest', () {
    test('equality and hashCode work as expected', () {
      const request1 = ThumbnailRequest(
        filePath: '/path/to/file.pdf',
        widgetSize: 250,
        mimeType: 'application/pdf',
        fileSize: 1024,
      );

      const request2 = ThumbnailRequest(
        filePath: '/path/to/file.pdf',
        widgetSize: 250,
        mimeType: 'application/pdf',
        fileSize: 1024,
      );

      const request3 = ThumbnailRequest(
        filePath: '/path/to/other.pdf',
        widgetSize: 250,
        mimeType: 'application/pdf',
        fileSize: 1024,
      );

      expect(request1, equals(request2));
      expect(request1.hashCode, equals(request2.hashCode));
      expect(request1, isNot(equals(request3)));
    });
  });

  group('ThumbnailDiskCache', () {
    test('generateKey creates deterministic md5 hash', () {
      final cache = ThumbnailDiskCache.instance;
      const request = ThumbnailRequest(
        filePath: '/sample/document.pdf',
        widgetSize: 200,
        fileSize: 5000,
      );

      final key1 = cache.generateKey(request);
      final key2 = cache.generateKey(request);

      expect(key1, isNotEmpty);
      expect(key1, equals(key2));
    });
  });

  group('FileIconMapper', () {
    test('maps standard file types to appropriate icons', () {
      expect(
        FileIconMapper.getIcon(mimeType: 'application/pdf'),
        Icons.picture_as_pdf_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'test.pdf'),
        Icons.picture_as_pdf_rounded,
      );
      expect(
        FileIconMapper.getIcon(mimeType: 'image/png'),
        Icons.image_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'photo.jpg'),
        Icons.image_rounded,
      );
      expect(
        FileIconMapper.getIcon(mimeType: 'video/mp4'),
        Icons.video_file_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'clip.mov'),
        Icons.video_file_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'archive.zip'),
        Icons.folder_zip_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'main.dart'),
        Icons.code_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'data.xlsx'),
        Icons.table_chart_rounded,
      );
      expect(
        FileIconMapper.getIcon(filePath: 'unknown.xyz'),
        Icons.insert_drive_file_rounded,
      );
    });
  });

  group('ThumbnailService', () {
    test('canGenerateImageThumbnail returns true for pdf, images, and videos', () {
      final service = ThumbnailService.instance;

      const pdfRequest = ThumbnailRequest(
        filePath: '/docs/report.pdf',
        widgetSize: 250,
        mimeType: 'application/pdf',
      );
      const imageRequest = ThumbnailRequest(
        filePath: '/pictures/photo.png',
        widgetSize: 250,
        mimeType: 'image/png',
      );
      const videoRequest = ThumbnailRequest(
        filePath: '/videos/recording.mp4',
        widgetSize: 250,
        mimeType: 'video/mp4',
      );
      const textRequest = ThumbnailRequest(
        filePath: '/docs/notes.txt',
        widgetSize: 250,
        mimeType: 'text/plain',
      );

      expect(service.canGenerateImageThumbnail(pdfRequest), isTrue);
      expect(service.canGenerateImageThumbnail(imageRequest), isTrue);
      expect(service.canGenerateImageThumbnail(videoRequest), isTrue);
      expect(service.canGenerateImageThumbnail(textRequest), isFalse);
    });

    test('VideoThumbnailGenerator handles video MIME and extensions', () {
      final generator = VideoThumbnailGenerator();
      expect(
        generator.canHandle(
          const ThumbnailRequest(filePath: 'clip.mp4', widgetSize: 200),
        ),
        isTrue,
      );
      expect(
        generator.canHandle(
          const ThumbnailRequest(
            filePath: 'stream',
            mimeType: 'video/quicktime',
            widgetSize: 200,
          ),
        ),
        isTrue,
      );
      expect(
        generator.canHandle(
          const ThumbnailRequest(filePath: 'image.png', widgetSize: 200),
        ),
        isFalse,
      );
    });
  });
}
