import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:clipboard/base/common/logging.dart';
import 'package:easy_worker/easy_worker.dart';
import 'package:image/image.dart' as img;
import 'package:mime/mime.dart' as mime;
import 'package:universal_io/io.dart';

String? calculateBlurHash(String path) {
  try {
    final bin = File(path).readAsBytesSync();
    final mimeType =
        mime.lookupMimeType(path, headerBytes: bin.sublist(0, 100));

    img.Image? image;

    switch (mimeType) {
      case "image/gif":
        image = img.decodeGif(bin);

      case "image/jpeg" || "image/jpg":
        image = img.decodeJpg(bin);

      case "image/png":
        image = img.decodePng(bin);

      case "image/webp":
        image = img.decodeWebP(bin);

      case "image/tiff":
        image = img.decodeTiff(bin);

      case _:
    }

    if (image == null) {
      return null;
    }
    final result = BlurHash.encode(image, numCompX: 4, numCompY: 3).hash;
    return result;
  } catch (e) {
    logger.e(
      "Couldn't get blur hash from the image!",
      error: e,
    );
    return null;
  }
}

void processBlurHash((String, String) payload, Sender send) {
  final (type, input) = payload;

  if (type == "encode") {
    // input is path
    final result = calculateBlurHash(input);
    send((null, result));
  } else if (type == "decode") {
    // input is blurHash
    final image_ = BlurHash.decode(input).toImage(35, 20);
    final bin = Uint8List.fromList(img.encodeJpg(image_));
    send((bin, null));
  }
}

final blurHashWorker = EasyCompute<(Uint8List?, String?), (String, String)>(
  ComputeEntrypoint(processBlurHash),
  workerName: "BlurHash Enc/Dec",
);

Future<String?> getBlurHash(String path) async {
  await blurHashWorker.waitUntilReady();
  final (_, blurHash) = await blurHashWorker.compute(("encode", path));

  return blurHash;
}

Future<Uint8List?> getImageFromBlurHash(String blurHash) async {
  await blurHashWorker.waitUntilReady();
  final (bin, _) = await blurHashWorker.compute(("decode", blurHash));
  return bin;
}
