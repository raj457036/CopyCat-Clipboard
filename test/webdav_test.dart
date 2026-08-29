import 'package:clipboard/base/domain/model/cloud_file_id/cloud_file_id.dart';
import 'package:clipboard/base/domain/model/webdav_config/webdav_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CloudFileId Tests', () {
    test('parses Google Drive file ID without prefix', () {
      const gDriveId = '1abc-xyz_12345';
      final parsed = CloudFileId.parse(gDriveId);

      expect(parsed.type, CloudStorageType.googleDrive);
      expect(parsed.pathOrId, gDriveId);
      expect(parsed.isGoogleDrive, isTrue);
      expect(parsed.isWebDav, isFalse);
      expect(parsed.format(), gDriveId);
    });

    test('parses WebDAV file ID with prefix', () {
      const webdavId = 'webdav:/CopyCat/media/clip_123.png';
      final parsed = CloudFileId.parse(webdavId);

      expect(parsed.type, CloudStorageType.webdav);
      expect(parsed.pathOrId, '/CopyCat/media/clip_123.png');
      expect(parsed.isWebDav, isTrue);
      expect(parsed.isGoogleDrive, isFalse);
      expect(parsed.format(), webdavId);
    });

    test('creates WebDAV CloudFileId via factory', () {
      final cloudId = CloudFileId.webdav('/folder/file.jpg');
      expect(cloudId.format(), 'webdav:/folder/file.jpg');
    });
  });

  group('WebDavConfig Tests', () {
    test('sanitizes basePath correctly', () {
      const config1 = WebDavConfig(
        serverUrl: 'https://cloud.example.com',
        username: 'user',
        password: 'pass',
        basePath: '.CopyCat/media/',
      );
      expect(config1.sanitizedBasePath, '/.CopyCat/media');

      const config2 = WebDavConfig(
        serverUrl: 'https://cloud.example.com',
        username: 'user',
        password: 'pass',
        basePath: '/.CopyCat/media',
      );
      expect(config2.sanitizedBasePath, '/.CopyCat/media');
    });

    test('serializes and deserializes to JSON correctly', () {
      const config = WebDavConfig(
        serverUrl: 'https://nextcloud.example.com/remote.php/dav/files/user/',
        username: 'test_user',
        password: 'test_password',
        basePath: '/custom/path',
        allowSelfSignedCert: true,
        autoCleanInactiveFiles: true,
      );

      final json = config.toJson();
      final fromJson = WebDavConfig.fromJson(json);

      expect(fromJson, equals(config));
      expect(fromJson.allowSelfSignedCert, isTrue);
      expect(fromJson.autoCleanInactiveFiles, isTrue);
      expect(fromJson.basePath, '/custom/path');
    });
  });
}
