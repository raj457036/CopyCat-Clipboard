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

/// Processes clipboard format data into a [ClipItem].
/// Handles text, images, URIs, and generic file formats with automatic extension resolution.
class ClipboardFormatProcessor {
  bool preventDuplicate = false;

  late final Map<DataFormat, Future<ClipItem?> Function(DataReader)> _handlers =
      <DataFormat, Future<ClipItem?> Function(DataReader)>{
        Formats.htmlText: _getHtml,
        Formats.plainText: _getPlainText,
        Formats.plainTextFile: _getPlainTextFile,
        Formats.fileUri: processUri,
        Formats.uri: processUri,
        for (final entry in _imageFormatExtensions.entries)
          entry.key: (reader) => getImage(reader, entry.value, entry.key),
      };

  static final Map<DataFormat, String> _imageFormatExtensions =
      <DataFormat, String>{
        Formats.png: "png",
        Formats.jpeg: "jpeg",
        Formats.gif: "gif",
        Formats.webp: "webp",
        Formats.bmp: "bmp",
        Formats.heic: "heic",
        Formats.heif: "heif",
        avif: "avif",
        Formats.tiff: "tiff",
        Formats.ico: "ico",
        svg: "svg",
      };

  String cleanText(String text) {
    try {
      return Uri.decodeComponent(cleanUpString(text) ?? '');
    } catch (e) {
      return cleanUpString(text) ?? '';
    }
  }

  String? _normalizeExtension(String? extension) {
    if (extension == null || extension.isEmpty) return null;
    final normalized = extension.startsWith('.')
        ? extension.substring(1)
        : extension;
    if (normalized.isEmpty) return null;
    return normalized.toLowerCase();
  }

  String? _extensionFromMimeType(String? mimeType) {
    if (mimeType == null || mimeType.isEmpty) return null;
    return _normalizeExtension(mime.extensionFromMime(mimeType));
  }

  String? _mimeTypeFromFormat(DataFormat format) {
    if (format is SimpleFileFormat) {
      final mimeTypes = format.mimeTypes;
      if (mimeTypes != null && mimeTypes.isNotEmpty) {
        return mimeTypes.first;
      }
    }
    return null;
  }

  String _extensionForFormat(
    DataFormat format, {
    String? fileNameExtension,
    String? preferredMimeType,
  }) {
    return _normalizeExtension(fileNameExtension) ??
        _imageFormatExtensions[format] ??
        _extensionFromMimeType(preferredMimeType) ??
        _extensionFromMimeType(_mimeTypeFromFormat(format)) ??
        "bin";
  }

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

  Future<({String? fileName, String? fileExtension, Uint8List? bytes})>
  readFile(DataReader reader, FileFormat format, {bool virtual = true}) async {
    Uint8List? bytes;
    String? fileName;
    String? fileExtension;
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
            fileName = _duplicateTag;
            return;
          }

          final sourceFileName = file.fileName;
          if (sourceFileName != null && sourceFileName.isNotEmpty) {
            fileName = p.basenameWithoutExtension(sourceFileName);
            fileExtension = _normalizeExtension(p.extension(sourceFileName));
          }
          final bin = await streamToUint8List(file.getStream());
          final digest = sha1.convert(bin);
          if (isDuplicate(
            type: ClipItemType.file,
            digest: digest,
            save: true,
          )) {
            logger.w("Duplicate File Digest Found!");
            c.complete();
            fileName = _duplicateTag;
            return;
          }
          bytes = bin;
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
    return (fileName: fileName, fileExtension: fileExtension, bytes: bytes);
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

  Future<ClipItem?> _getHtml(DataReader reader) async {
    String? text;

    try {
      text = await readValue(reader, Formats.htmlText);
    } catch (e) {
      final data = await service.Clipboard.getData("text/html");
      if (data != null) text = data.text;
    }

    if (text == null) {
      logger.w("Text is null");
      return null;
    }

    return ClipItem.text(text: text, textCategory: TextCategory.struct);
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
    final fileData = await readFile(reader, Formats.plainTextFile);
    final fileName = fileData.fileName;
    final binary = fileData.bytes;

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
    return _getFileFormatClip(
      reader,
      format: format as FileFormat,
      preferredExtension: ext,
      preferredMimeType: _mimeTypeFromFormat(format),
      folder: "medias",
      type: ClipItemType.media,
    );
  }

  Future<ClipItem?> _getFileFormatClip(
    DataReader reader, {
    required FileFormat format,
    String? preferredExtension,
    String? preferredMimeType,
    required String folder,
    required ClipItemType type,
  }) async {
    try {
      ({String? fileName, String? fileExtension, Uint8List? bytes}) result;
      final tryVirtualFirst = Platform.isWindows;
      try {
        result = await readFile(
          reader,
          format,
          virtual: tryVirtualFirst,
        ).timeout(const Duration(seconds: 3));
      } on TimeoutException catch (e) {
        logger.e(e);
        result = await readFile(
          reader,
          format,
          virtual: !tryVirtualFirst,
        ).timeout(const Duration(seconds: 10));
      } catch (e) {
        logger.e(e);
        return null;
      }

      final fileName = result.fileName;
      final binary = result.bytes;
      if (fileName == _duplicateTag) return ClipItem.duplicate();
      if (binary == null) {
        logger.w("Couldn't read content of image file with format $format");
        return null;
      }
      final resolvedExtension = _extensionForFormat(
        format,
        fileNameExtension: result.fileExtension ?? preferredExtension,
        preferredMimeType: preferredMimeType,
      );
      final (file, mimeType, size) = await writeToClipboardCacheFile(
        folder: folder,
        ext: resolvedExtension,
        fileName: fileName,
        content: binary,
      );
      if (file == null) return null;
      final resolvedMimeType =
          mimeType ?? preferredMimeType ?? _mimeTypeFromFormat(format);
      if (type == ClipItemType.media) {
        return ClipItem.imageFile(
          file: file,
          mimeType: resolvedMimeType ?? "application/octet-stream",
          fileName: fileName,
          fileSize: size,
        );
      }

      return ClipItem.file(
        file: file,
        mimeType: resolvedMimeType ?? "application/octet-stream",
        fileName: fileName,
        fileSize: size,
      );
    } catch (e) {
      return null;
    }
  }

  Future<ClipItem?> _getGenericFile(
    DataReader reader,
    FileFormat format,
  ) async {
    return _getFileFormatClip(
      reader,
      format: format,
      preferredMimeType: _mimeTypeFromFormat(format),
      folder: "files",
      type: ClipItemType.file,
    );
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

  Future<ClipItem?> process(
    DataReader reader,
    DataFormat format, {
    bool preventDuplicate = false,
  }) async {
    try {
      this.preventDuplicate = preventDuplicate;
      final handler = _handlers[format];
      if (handler != null) {
        return await handler(reader);
      }

      if (format is FileFormat) {
        return await _getGenericFile(reader, format);
      }

      logger.i("Unsupported clipboard format: $format");
      return null;
    } finally {
      this.preventDuplicate = false;
    }
  }
}
