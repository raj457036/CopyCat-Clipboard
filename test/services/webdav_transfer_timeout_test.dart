import 'dart:io';

import 'package:clipboard/base/bloc/app_config_cubit/app_config_cubit.dart';
import 'package:clipboard/base/data/services/file_cloud_services/webdav/webdav_file_cloud_service.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/model/webdav_config/webdav_config.dart';
import 'package:clipboard/base/domain/repositories/webdav_credential.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _Config implements AppConfigCubit {
  @override
  bool get isFileSyncEnabled => true;

  @override
  bool canUploadFile(int size) => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Credentials implements WebDavCredentialRepository {
  final WebDavConfig config;

  _Credentials(this.config);

  @override
  FailureOr<WebDavConfig?> getConfig() async => Right(config);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'a stalled directory request fails, and manual retry can upload',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      final directory = await Directory.systemTemp.createTemp(
        'copycat-webdav-test-',
      );
      final file = await File(
        '${directory.path}/clip.txt',
      ).writeAsString('clip');
      final requests = <String>[];
      var stallDirectory = true;
      final subscription = server.listen((request) async {
        requests.add(request.method);
        if (request.method == 'MKCOL' && stallDirectory) {
          return;
        }
        if (request.method == 'PUT') {
          expect(
            await request.fold<int>(0, (size, bytes) => size + bytes.length),
            4,
          );
        } else {
          await request.drain<void>();
        }
        request.response.statusCode = request.method == 'DELETE' ? 204 : 201;
        await request.response.close();
      });
      addTearDown(() async {
        await server.close(force: true);
        await subscription.cancel();
        await file.delete();
        await directory.delete();
      });

      final service = WebDavFileCloudService(
        _Credentials(
          WebDavConfig(
            serverUrl: 'http://${server.address.address}:${server.port}',
            username: 'test',
            password: 'test',
            basePath: '/clips',
          ),
        ),
        _Config(),
      );
      final item = ClipboardItem(
        id: 1,
        created: DateTime.now(),
        modified: DateTime.now(),
        type: ClipItemType.file,
        userId: 'test-user',
        os: PlatformOS.macos,
        localPath: file.path,
        fileName: 'clip.txt',
        fileSize: 4,
        fileMimeType: 'text/plain',
      );

      final failure = await service.upload(item);
      expect(failure.fold((f) => f.code, (_) => null), 'webdav-timeout');
      expect(requests, ['MKCOL']);

      stallDirectory = false;
      final retried = await service.upload(item);
      expect(retried.isRight(), isTrue);
      final uploaded = retried.getOrElse(
        () => throw StateError('Upload failed'),
      );
      expect(uploaded.driveFileId, startsWith('webdav:/clips/'));
      expect((await service.delete(uploaded)).isRight(), isTrue);
      expect(requests, ['MKCOL', 'MKCOL', 'PUT', 'DELETE']);
    },
  );
}
