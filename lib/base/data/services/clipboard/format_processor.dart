import 'dart:async' show Completer, TimeoutException;
import 'dart:convert' show utf8;

import 'package:clipboard/base/constants/misc.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/services/clipboard/clip_models.dart';
import 'package:clipboard/base/domain/services/analysis/text_analysis.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:crypto/crypto.dart' show sha1, Digest;
import 'package:easy_worker/easy_worker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' as service;
import 'package:mime/mime.dart' as mime;
import 'package:path/path.dart' as p;
import 'package:super_clipboard/super_clipboard.dart';
import 'package:universal_io/io.dart';

// ---------------------------------------------------------------------------
// Globals used for duplicate detection across clipboard reads.
// ---------------------------------------------------------------------------

ImmediateClip? _immediateClip;
const _duplicateTag = "<-Duplicate";

// ---------------------------------------------------------------------------
// Isolate-safe file-copy helper (passed to EasyWorker.compute).
// ---------------------------------------------------------------------------

void copyFile((String, String) paths, Sender sender) {
  final (from, to) = paths;
  final fromFile = File(from);
  try {
    fromFile.copySync(to);
    sender(true);
  } catch (e) {
    logger.e("Failed to copy file in isolate", error: e);
    sender(false);
  }
}

// ---------------------------------------------------------------------------
// Cache-file writer — persists raw bytes / text into the app cache directory.
// ---------------------------------------------------------------------------

/// Writes clipboard content to a local cache file and returns
/// `(file, mimeType, sizeInBytes)`. At least one of [content], [textContent],
/// or [file] must be provided.
Future<(File?, String?, int)> writeToClipboardCacheFile({
  required String folder,
  required String ext,
  String? fileName,
  Uint8List? content,
  String? textContent,
  File? file,
}) async {
  assert(
    !(file == null && content == null && textContent == null),
    "Provide at least one of content, textContent or file",
  );

  final appDirPath = await getPersistedRootDirPath();
  final directory = p.join(appDirPath, folder);
  await createDirectoryIfNotExists(directory);
  final path = p.join(directory, "${getId()}_${fileName ?? ''}.$ext");
  final file_ = File(path);

  if (file != null) {
    await EasyWorker.compute(copyFile, (
      file.uri.toFilePath(windows: Platform.isWindows),
      path,
    ), name: "Copy File");
    return (file_, mime.lookupMimeType(file.path), await file.length());
  } else if (textContent != null) {
    await file_.writeAsString(textContent);
    return (file_, "text/plain", textContent.length);
  } else if (content != null) {
    await file_.writeAsBytes(content, flush: true);
    return (
      file_,
      mime.lookupMimeType(path, headerBytes: content.sublist(0, 100)),
      content.length,
    );
  }
  return (null, null, 0);
}

// ---------------------------------------------------------------------------
// ClipboardFormatProcessor
// ---------------------------------------------------------------------------

/// Processes a [DataReader] + [DataFormat] pair into a [ClipItem].
///
/// Handles plain text, plain-text files, images, and URI/file formats.
/// Duplicate detection is controlled via [preventDuplicate].
class ClipboardFormatProcessor {
  bool preventDuplicate = false;

  String cleanText(String text) {
    try {
      return Uri.decodeComponent(cleanUpString(text) ?? '');
    } catch (e) {
      return cleanUpString(text) ?? '';
    }
  }

  /// Reads a single [ValueFormat] value from [reader]. Returns `null` when
  /// the format is not available or reading fails.
  Future<T?> readValue<T extends Object>(
    DataReader reader,
    ValueFormat<T> format,
  ) async {
    final canProvide = reader.canProvide(format);
    if (!canProvide) return null;
    final completer = Completer<T?>();
    reader.getValue<T>(
      format,
      (value) => completer.complete(value),
      onError: (error) => completer.completeError(error),
    );
    return completer.future;
  }

  Future<Uint8List> streamToUint8List(Stream<Uint8List> stream) async {
    final bytes = <int>[];
    await for (final chunk in stream) {
      bytes.addAll(chunk);
    }
    return Uint8List.fromList(bytes);
  }

  /// Reads a file payload from [reader] using [format].
  /// Returns `(fileName, bytes)` — both may be null on failure.
  Future<(String?, Uint8List?)> readFile(
    DataReader reader,
    FileFormat format, {
    bool virtual = true,
  }) async {
    Uint8List? content;
    String? name;
    final c = Completer<void>();
    final progress = reader.getFile(
      format,
      (file) async {
        try {
          if (file.fileName != null &&
              isDuplicate(
                type: ClipItemType.file,
                path: file.fileName,
                save: true,
              )) {
            logger.w("Duplicate File Clip Found!");
            c.complete();
            name = _duplicateTag;
            return;
          }

          name = p.basenameWithoutExtension(file.fileName ?? "");
          final bin = await streamToUint8List(file.getStream());
          final digest = sha1.convert(bin);

          if (isDuplicate(
            type: ClipItemType.file,
            digest: digest,
            save: true,
          )) {
            logger.w("Duplicate File Digest Found!");
            c.complete();
            name = _duplicateTag;
            return;
          }

          content = bin;
          c.complete();
        } catch (e) {
          c.completeError(e);
        }
      },
      onError: (e) => c.completeError(e),
      allowVirtualFiles: virtual,
    );
    if (progress == null) c.complete();
    await c.future;
    return (name, content);
  }

  ImmediateClip? getImmediateClip({
    required ClipItemType type,
    String? text,
    String? path,
    Digest? digest,
    Uri? uri,
  }) {
    if (type == ClipItemType.text && text != null) {
      return ImmediateClip(type: type, text: text);
    }
    if ((type == ClipItemType.media || type == ClipItemType.file) &&
            path != null ||
        digest != null) {
      return ImmediateClip(type: type, ogFilePath: path, digest: digest);
    }
    if (type == ClipItemType.url && uri != null) {
      return ImmediateClip(type: type, uri: uri);
    }
    return null;
  }

  bool isDuplicate({
    required ClipItemType type,
    String? text,
    String? path,
    Digest? digest,
    Uri? uri,
    bool save = false,
  }) {
    if (!preventDuplicate) return false;
    final ic = getImmediateClip(
      type: type,
      text: text,
      path: path,
      digest: digest,
      uri: uri,
    );
    final isDuplicate_ = ic == _immediateClip && ic != null;
    if (save && ic != null) {
      _immediateClip = ic;
    }
    return isDuplicate_;
  }

  Future<ClipItem?> _getPlainText(DataReader reader) async {
    String? text;
    try {
      text = await readValue(reader, Formats.plainText);
    } catch (e) {
      final data = await service.Clipboard.getData("text/plain");
      if (data != null) text = data.text;
    }

    if (text == null) {
      logger.w("Text is null");
      return null;
    }

    text = cleanText(text);
    if (text.trim().isEmpty) return null;
    text = text.replaceAll(RegExp('\r[\n]?'), '\n');
    final (textCategory, parsedText) = TextAnalysis.getTextCategory(text);

    if (isDuplicate(type: ClipItemType.text, text: parsedText, save: true)) {
      logger.w("Duplicate Text Clip Found!");
      return ClipItem.duplicate();
    }

    return ClipItem.text(text: parsedText, textCategory: textCategory);
  }

  Future<ClipItem?> _getPlainTextFile(DataReader reader) async {
    final (fileName, binary) = await readFile(reader, Formats.plainTextFile);

    if (fileName == _duplicateTag) return ClipItem.duplicate();
    if (binary == null) {
      logger.w("Text file is null or empty.");
      return null;
    }

    final text = cleanText(utf8.decode(binary, allowMalformed: true));
    if (text.isNotEmpty && text.length <= 1024) {
      return ClipItem.text(text: text);
    }

    final (file, mimeType, size) = await writeToClipboardCacheFile(
      folder: "files",
      ext: "txt",
      fileName: fileName,
      textContent: text,
    );
    if (file == null) return null;

    return ClipItem.file(
      file: file,
      mimeType: mimeType ?? "application/octet-stream",
      textPreview: text,
      fileName: fileName,
      fileSize: size,
    );
  }

  Future<ClipItem?> getImage(
    DataReader reader,
    String ext,
    DataFormat format,
  ) async {
    try {
      (String?, Uint8List?) result;
      final tryVirtualFirst = Platform.isWindows;
      try {
        result = await readFile(
          reader,
          format as FileFormat,
          virtual: tryVirtualFirst,
        ).timeout(const Duration(seconds: 3));
      } on TimeoutException catch (e) {
        logger.e(e);
        result = await readFile(
          reader,
          format as FileFormat,
          virtual: !tryVirtualFirst,
        ).timeout(const Duration(seconds: 10));
      } catch (e) {
        logger.e(e);
        return null;
      }

      final (fileName, binary) = result;
      if (fileName == _duplicateTag) return ClipItem.duplicate();
      if (binary == null) {
        logger.w("Couldn't read content of image file with format $format");
        return null;
      }

      final (file, mimeType, size) = await writeToClipboardCacheFile(
        folder: "medias",
        ext: ext,
        fileName: fileName,
        content: binary,
      );
      if (file == null) return null;

      return ClipItem.imageFile(
        file: file,
        mimeType: mimeType ?? "application/octet-stream",
        fileName: fileName,
        fileSize: size,
      );
    } catch (e) {
      return null;
    }
  }

  Future<ClipItem?> getFile(DataReader reader, Uri uri) async {
    File file;
    try {
      file = File(uri.toFilePath(windows: Platform.isWindows));
    } catch (e) {
      logger.e(e);
      return null;
    }

    if (!await file.exists()) {
      logger.w("Couldn't find file at $uri");
      return null;
    }

    if (isDuplicate(type: ClipItemType.file, path: file.path, save: true)) {
      logger.w("Duplicate File Clip Found!");
      return ClipItem.duplicate();
    }

    final ext = p.extension(file.path).substring(1);
    final fileName = p.basenameWithoutExtension(file.path);
    final (cacheFile, mimeType, size) = await writeToClipboardCacheFile(
      folder: "files",
      ext: ext,
      file: file,
      fileName: fileName,
    );
    if (cacheFile == null) return null;

    return ClipItem.file(
      file: cacheFile,
      mimeType: mimeType ?? "application/octet-stream",
      fileName: fileName,
      fileSize: size,
    );
  }

  Future<ClipItem> getUrl(DataReader reader, NamedUri uri) async {
    final schema = uri.uri.scheme;
    if (supportedUriSchemas.contains(schema)) {
      return ClipItem.uri(uri: uri.uri);
    }
    logger.w("Unsupported uri schema: $schema. Converting to text.");
    return ClipItem.text(text: cleanText(uri.uri.toString()));
  }

  Future<ClipItem?> processUri(DataReader reader) async {
    final fileUriFuture = readValue(reader, Formats.fileUri);
    final uriFuture = readValue(reader, Formats.uri);

    final fileUri = await fileUriFuture;
    if (fileUri != null) return await getFile(reader, fileUri);

    NamedUri? uri;
    try {
      uri = await uriFuture;
    } catch (e) {
      return await _getPlainText(reader);
    }

    if (uri != null) {
      if (isDuplicate(type: ClipItemType.url, uri: uri.uri, save: true)) {
        logger.w("Duplicate Uri Clip Found!");
        return ClipItem.duplicate();
      }
      return await getUrl(reader, uri);
    }

    logger.i("Uri couldn't be parsed, trying with text.");
    return await _getPlainText(reader);
  }

  /// Dispatches [reader] + [format] to the appropriate handler and returns
  /// a [ClipItem], or `null` if nothing could be extracted.
  Future<ClipItem?> process(
    DataReader reader,
    DataFormat format, {
    bool preventDuplicate = false,
  }) async {
    try {
      this.preventDuplicate = preventDuplicate;
      switch (format) {
        case Formats.plainText:
          return await _getPlainText(reader);
        case Formats.plainTextFile:
          return await _getPlainTextFile(reader);
        case avif:
          return await getImage(reader, "avif", format);
        case Formats.png:
          return await getImage(reader, "png", format);
        case Formats.jpeg:
          return await getImage(reader, "jpeg", format);
        case Formats.gif:
          return await getImage(reader, "gif", format);
        case Formats.tiff:
          return await getImage(reader, "tiff", format);
        case Formats.webp:
          return await getImage(reader, "webp", format);
        case Formats.heic:
          return await getImage(reader, "heic", format);
        case svg:
          return await getImage(reader, "svg", format);
        case Formats.fileUri:
        case Formats.uri:
          return await processUri(reader);
        default:
          return null;
      }
    } finally {
      this.preventDuplicate = false;
    }
  }
}
