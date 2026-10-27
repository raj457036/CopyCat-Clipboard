import 'dart:async';
import 'dart:io';

import 'package:clipboard/base/background/blur_hash_worker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  late Directory directory;
  late File image;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('copycat-blurhash-test-');
    image = File('${directory.path}/image.jpg');
    await image.writeAsBytes(img.encodeJpg(img.Image(width: 8, height: 8)));
    await blurHashWorker.waitUntilReady();
    await Future<void>.delayed(Duration.zero);
  });

  tearDownAll(() async {
    blurHashWorker.dispose();
    await image.delete();
    await directory.delete();
  });

  test('a stalled image task fails and a later attempt can succeed', () async {
    final hash = await getBlurHash(image.path);
    expect(hash, isNotNull);
    expect(await getImageFromBlurHash(hash!), isNotEmpty);

    blurHashWorker.pause();
    try {
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await expectLater(
        getBlurHash(image.path),
        throwsA(isA<TimeoutException>()),
      );
    } finally {
      blurHashWorker.resume();
    }

    expect(await getBlurHash(image.path), hash);
  });
}
