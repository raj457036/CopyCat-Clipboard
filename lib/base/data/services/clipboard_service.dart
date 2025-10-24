import 'dart:async' show Completer, TimeoutException;
import 'dart:async' show FutureOr;
import 'dart:convert' show utf8;

import 'package:clipboard/base/constants/misc.dart';
import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:crypto/crypto.dart' show sha1, Digest;
import 'package:easy_worker/easy_worker.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as service;
import 'package:injectable/injectable.dart';
import 'package:mime/mime.dart' as mime;
import "package:path/path.dart" as p;
import 'package:rxdart/rxdart.dart';
import 'package:super_clipboard/super_clipboard.dart';
import "package:universal_io/io.dart";
import 'package:window_manager/window_manager.dart';

class ImmediateClip extends Equatable {
  final ClipItemType type;
  final String? text;
  final Uri? uri;
  final Digest? digest;
  final String? ogFilePath;

  const ImmediateClip({
    required this.type,
    this.text,
    this.uri,
    this.ogFilePath,
    this.digest,
  });

  @override
  List<Object?> get props => [type, text, uri, ogFilePath, digest];
}

class ClipItem {
  final ClipItemType type;
  final File? file;
  final String? fileName;
  final String? fileMimeType;
  final String? fileExtension;
  final String? blurHash;
  final int? fileSize;
  final String? text;
  final Uri? uri;
  final TextCategory? textCategory;
  final bool isDuplicate;

  ClipItem({
    required this.type,
    required this.file,
    required this.fileName,
    required this.text,
    required this.uri,
    required this.fileMimeType,
    required this.fileExtension,
    required this.fileSize,
    this.textCategory,
    this.blurHash,
    this.isDuplicate = false,
  });

  bool get isImage => fileMimeType?.startsWith("image") ?? false;
  bool get isVideo => fileMimeType?.startsWith("video") ?? false;
  bool get isAudio => fileMimeType?.startsWith("audio") ?? false;
  bool get isText => type == ClipItemType.text;
  bool get isUri => type == ClipItemType.url;
  bool get isFile => type == ClipItemType.file;
  bool get isTextSubType =>
      type == ClipItemType.text || type == ClipItemType.url;

  Future<void> cleanup() async {
    if (file != null && await file!.exists()) {
      await file!.delete();
    }
  }

  factory ClipItem.duplicate() => ClipItem(
        type: ClipItemType.text,
        file: null,
        fileName: null,
        text: null,
        uri: null,
        fileMimeType: null,
        fileExtension: null,
        fileSize: null,
        isDuplicate: true,
      );

  factory ClipItem.text({
    required String text,
    TextCategory? textCategory,
  }) =>
      ClipItem(
        file: null,
        fileName: null,
        uri: null,
        text: text,
        type: ClipItemType.text,
        fileMimeType: null,
        fileExtension: null,
        fileSize: null,
        textCategory: textCategory,
      );

  factory ClipItem.uri({
    required Uri uri,
  }) =>
      ClipItem(
        file: null,
        fileName: null,
        uri: uri,
        text: null,
        type: ClipItemType.url,
        fileMimeType: null,
        fileExtension: null,
        fileSize: null,
      );

  factory ClipItem.imageFile({
    required File file,
    String? fileName,
    required String mimeType,
    required int fileSize,
    String? blurHash,
  }) =>
      ClipItem(
        fileName: fileName,
        file: file,
        uri: null,
        text: null,
        type: ClipItemType.media,
        fileMimeType: mimeType,
        fileExtension: p.extension(file.path),
        fileSize: fileSize,
        blurHash: blurHash,
      );

  factory ClipItem.file({
    required File file,
    String? textPreview,
    String? fileName,
    required String mimeType,
    required int fileSize,
  }) =>
      ClipItem(
        file: file,
        fileName: fileName,
        uri: null,
        text: textPreview,
        type: ClipItemType.file,
        fileMimeType: mimeType,
        fileExtension: p.extension(file.path),
        fileSize: fileSize,
      );
}

ImmediateClip? _immediateClip;
const _duplicateTag = "<-Duplicate";
final rgbRegex = RegExp(
    r"^#?(?:[0-9a-fA-F]{3}){1,2}$|^#(?:[0-9a-fA-F]{4}){2}$"); // ABC, FFAAAA, #AAA, #FAB, #FFAABBCC
final emailRegex = RegExp(
    r"^([a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9\-\_]+(\.[a-zA-Z]+)*)$");
final phoneRegex = RegExp(r'^\+?\d{0,2}\s?\d{7,15}$');

(bool, String) parseColor(String value) {
  final colorHex = rgbRegex.stringMatch(value);
  if (colorHex != null) {
    return (true, colorHex);
  }
  return (false, value);
}

(bool, String) parseEmail(String value) {
  final email = emailRegex.stringMatch(value);
  if (email != null) {
    return (true, email);
  }
  return (false, value);
}

(bool, String) parsePhone(String value) {
  final phone = phoneRegex.stringMatch(value);
  if (phone != null) {
    return (true, phone);
  }
  return (false, value);
}

(TextCategory?, String) getTextCategory(String value) {
  final (isColor, color) = parseColor(value);
  if (isColor) return (TextCategory.color, color);

  final (isEmail, email) = parseEmail(value);
  if (isEmail) return (TextCategory.email, email);

  final (isPhone, phone) = parsePhone(value);
  if (isPhone) return (TextCategory.phone, phone);

  return (null, value);
}

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

Future<(File?, String?, int)> writeToClipboardCacheFile({
  required String folder,
  required String ext,
  String? fileName,
  Uint8List? content,
  String? textContent,
  File? file,
}) async {
  /// returns file, mimetype and size
  assert(
    !(file == null && content == null && textContent == null),
    "Provide atleast one of content, textContent or file",
  );

  final appDirPath = await getPersistedRootDirPath();

  final directory = p.join(appDirPath, folder);
  await createDirectoryIfNotExists(directory);
  var path = p.join(directory, "${getId()}_${fileName ?? ''}.$ext");
  final file_ = File(path);

  if (file != null) {
    // await copyFile(file.path, path);
    await EasyWorker.compute(
      copyFile,
      (file.uri.toFilePath(windows: Platform.isWindows), path),
      name: "Copy File",
    );

    return (file_, mime.lookupMimeType(file.path), await file.length());
  } else if (textContent != null) {
    await file_.writeAsString(textContent);
    return (file_, "text/plain", textContent.length);
  } else if (content != null) {
    await file_.writeAsBytes(content, flush: true);
    return (
      file_,
      mime.lookupMimeType(
        path,
        headerBytes: content.sublist(0, 100),
      ),
      content.length,
    );
  }
  return (null, null, 0);
}

class ClipboardFormatProcessor {
  bool preventDuplicate = false;

  String cleanText(String text) {
    try {
      return Uri.decodeComponent(cleanUpString(text) ?? '');
    } catch (e) {
      return cleanUpString(text) ?? '';
    }
  }

  Future<T?> readValue<T extends Object>(
    DataReader reader,
    ValueFormat<T> format,
  ) async {
    final canProvide = reader.canProvide(format);
    if (!canProvide) return null;
    final completer = Completer<T?>();
    reader.getValue<T>(format, (value) {
      if (value != null) {
        completer.complete(value);
        return;
      }
      completer.complete(null);
    }, onError: (error) {
      completer.completeError(error);
    });

    return completer.future;
  }

  Future<Uint8List> streamToUint8List(Stream<Uint8List> stream) async {
    List<int> bytes = [];

    await for (Uint8List chunk in stream) {
      bytes.addAll(chunk);
    }

    return Uint8List.fromList(bytes);
  }

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
          // duplicate prevention
          if (file.fileName != null &&
              isDuplicate(
                  type: ClipItemType.file, path: file.fileName, save: true)) {
            logger.w("Duplicate File Clip Found!");
            c.complete();
            name = _duplicateTag;
            return;
          }

          name = p.basenameWithoutExtension(file.fileName ?? "");
          final bin = await streamToUint8List(file.getStream());

          final digest = sha1.convert(bin);

          // Duplicate prevention
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
      onError: (e) {
        c.completeError(e);
      },
      allowVirtualFiles: virtual,
    );
    if (progress == null) {
      c.complete();
    }
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
    ImmediateClip? ic;
    if (type == ClipItemType.text && text != null) {
      ic = ImmediateClip(type: type, text: text);
    }
    if ((type == ClipItemType.media || type == ClipItemType.file) &&
            path != null ||
        digest != null) {
      ic = ImmediateClip(type: type, ogFilePath: path, digest: digest);
    }
    if (type == ClipItemType.url && uri != null) {
      ic = ImmediateClip(type: type, uri: uri);
    }
    if (type == ClipItemType.url && uri != null) {
      ic = ImmediateClip(type: type, uri: uri);
    }
    return ic;
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

      if (data != null) {
        text = data.text;
      }
    }

    if (text == null) {
      logger.w("Text is null");
      return null;
    } else {
      text = cleanText(text);

      if (text.trim().isEmpty) return null;
      text = text.replaceAll(RegExp('\r[\n]?'), '\n');
      final (textCategory, parsedText) = getTextCategory(text);

      // duplicate prevention
      if (isDuplicate(type: ClipItemType.text, text: parsedText, save: true)) {
        logger.w("Duplicate Text Clip Found!");
        return ClipItem.duplicate();
      }

      return ClipItem.text(
        text: parsedText,
        textCategory: textCategory,
      );
    }
  }

  Future<ClipItem?> _getPlainTextFile(DataReader reader) async {
    final (fileName, binary) = await readFile(reader, Formats.plainTextFile);

    if (fileName == _duplicateTag) {
      return ClipItem.duplicate();
    }
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

      if (fileName == _duplicateTag) {
        return ClipItem.duplicate();
      }

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

  Future<ClipItem?> getFile(
    DataReader reader,
    Uri uri,
  ) async {
    File file;
    try {
      final filePath = uri.toFilePath(windows: Platform.isWindows);
      file = File(filePath);
    } catch (e) {
      logger.e(e);
      return null;
    }

    // check if file exists
    final exists = await file.exists();
    if (!exists) {
      logger.w("Couldn't find file at $uri");
      return null;
    }

    // duplicate prevention
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
    final isSupported = supportedUriSchemas.contains(schema);
    if (isSupported) {
      return ClipItem.uri(uri: uri.uri);
    } else {
      logger.w("Unsupported uri schema: $schema. Converting to text.");
      return ClipItem.text(text: cleanText(uri.uri.toString()));
    }
  }

  Future<ClipItem?> processUri(DataReader reader) async {
    // Make sure to request both values before awaiting
    final fileUriFuture = readValue(reader, Formats.fileUri);
    final uriFuture = readValue(reader, Formats.uri);

    // try file first and if it fails try regular URI
    final fileUri = await fileUriFuture;

    if (fileUri != null) {
      return await getFile(reader, fileUri);
    }

    NamedUri? uri;

    try {
      uri = await uriFuture;
    } catch (e) {
      return await _getPlainText(reader);
    }

    if (uri != null) {
      // duplicate prevention
      if (isDuplicate(type: ClipItemType.url, uri: uri.uri, save: true)) {
        logger.w("Duplicate Uri Clip Found!");
        return ClipItem.duplicate();
      }
      return await getUrl(reader, uri);
    }

    logger.i("Uri couldn't be parsed, trying with text.");

    return await _getPlainText(reader);
  }

  Future<ClipItem?> process(DataReader reader, DataFormat format,
      {bool preventDuplicate = false}) async {
    try {
      this.preventDuplicate = preventDuplicate;
      switch (format) {
        case Formats.plainText:
          return await _getPlainText(reader);
        case Formats.plainTextFile:
          return await _getPlainTextFile(reader);
        // Images
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

        // Files or Url
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

@singleton
class ClipboardService with ClipboardListener {
  bool _writing = false;
  bool _started = false;
  var _clipTypePriority = <DataFormat>[
    Formats.fileUri,
    Formats.uri,
    Formats.plainText,
    Formats.plainTextFile,
    avif,
    Formats.png,
    Formats.jpeg,
    Formats.gif,
    Formats.tiff,
    Formats.webp,
    Formats.heic,
    Formats.bmp,
    svg,
  ];

  void Function()? onRead;
  BehaviorSubject<List<ClipItem?>>? onCopy;
  final ClipboardFormatProcessor processor = ClipboardFormatProcessor();
  ClipboardWatcher get watcher => clipboardWatcher;

  Future<ClipboardReader?> getReader() async =>
      await SystemClipboard.instance?.read();

  void setWriting([bool writing = false]) {
    _writing = writing;
  }

  void updateSupportedTypes(List<DataFormat> updatedList) {
    _clipTypePriority = updatedList;
  }

  Future<void> write(Iterable<DataWriterItem> items) async {
    setWriting(true);
    await SystemClipboard.instance?.write(items);
    Future.delayed(Durations.short2, setWriting);
  }

  Future<void> start([void Function()? onRead]) async {
    if (_started) return;
    _started = true;
    this.onRead = onRead;
    onCopy = BehaviorSubject<List<ClipItem?>>();
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      watcher.addListener(this);
      await watcher.start();
    }
  }

  Future<void> dispose() async {
    if (!_started) return;
    _started = false;
    onRead = null;
    watcher.removeListener(this);
    await watcher.stop();
    await onCopy?.close();
  }

  @override
  void onClipboardChanged() {
    if (_writing) return;

    if (onRead != null) {
      onRead!();
    } else {
      readClipboard();
    }
  }

  Future<List<ClipItem?>?> readClipboard({
    bool manual = false,
    preventDuplicate = false,
  }) async {
    logger.i("Reading clipboard");
    await Future.delayed(Durations.short2);
    final reader = await getReader();

    if (reader == null) {
      logger.e("Clipboard is not available!");
      return null;
    }

    if (reader.items.isEmpty) {
      logger.w("No item in clipboard");
      return null;
    }

    final res = <DataFormat>{};

    for (final item in reader.items) {
      DataFormat? selectedFormat;
      final itemFormats = item.getFormats(allSupportedClipFormats);
      selectedFormat = filterOutByPriority(
        itemFormats,
      );
      if (selectedFormat != null) {
        res.add(selectedFormat);
      }
    }

    final clips = await processSingleReaderDataFormat(
      reader,
      res,
      manual: manual,
      preventDuplicate: preventDuplicate,
    );
    return clips;
  }

  DataFormat? filterOutByPriority(List<DataFormat> itemFormats) {
    DataFormat? selectedFormat;

    int currentPrefScore =
        _clipTypePriority.length; // Initialize to max possible priority index

    for (final format in itemFormats) {
      // Get the index of the current format in the priority list.
      final pref = _clipTypePriority.indexOf(format);

      // Check if the format is present in the priority list (index != -1).
      // If it has a higher priority (lower index), update the selected format.
      if (pref != -1 && pref < currentPrefScore) {
        selectedFormat = format;
        currentPrefScore =
            pref; // Update the score to reflect the new priority.
      }
    }

    return selectedFormat ?? Formats.plainText;
  }

  Future<List<ClipItem?>?> processMultipleReaderDataFormat(
    Iterable<(DataReader, DataFormat<Object>)> readerSet, {
    bool manual = false,
  }) async {
    final clips = await Future.wait(
      readerSet.map(
        (record) {
          final (reader, format) = record;
          return processor.process(reader, format);
        },
      ),
    );

    if (manual) {
      return clips;
    }

    onCopy?.add(clips);
    return null;
  }

  Future<List<ClipItem?>?> processSingleReaderDataFormat(
    DataReader reader,
    Iterable<DataFormat<Object>> data, {
    bool manual = false,
    bool preventDuplicate = false,
  }) async {
    final clips = await Future.wait(
      data.map(
        (format) {
          return processor.process(
            reader,
            format,
            preventDuplicate: preventDuplicate && !manual,
          );
        },
      ),
    );

    if (manual) {
      return clips;
    }

    onCopy?.add(clips);
    return null;
  }
}

class CopyToClipboard {
  final ClipboardService service;

  CopyToClipboard(this.service);

  Future<bool> writeToClipboard(DataWriterItem item) async {
    try {
      await service.write([item]);
      return true;
    } catch (e) {
      logger.e(e);
      return false;
    }
  }

  Future<bool> text(String text) {
    final item = DataWriterItem();
    item.add(Formats.plainText(text));
    return writeToClipboard(item);
  }

  Future<bool> url(Uri? uri) {
    if (uri == null) return Future.value(false);
    final item = DataWriterItem();
    item.add(Formats.uri(NamedUri(uri)));
    return writeToClipboard(item);
  }

  Future<bool> fileContent(File file, {String? mimeType}) async {
    FutureOr<EncodedData>? format;

    for (final f in allSupportedClipFormats) {
      if (f is SimpleFileFormat) {
        final mime_ = mimeType ?? mime.lookupMimeType(file.path);
        final isThis = f.mimeTypes?.contains(mime_);
        if (isThis != null && isThis) {
          format = f.lazy(() => file.readAsBytes());
          break;
        }
      }
    }

    if (format == null) {
      logger.w(
        "Couldn't determine mime type for file ${file.path} with mime type $mimeType",
      );

      return await saveFile(file);
    }

    final item = DataWriterItem()..add(format);
    return writeToClipboard(item);
  }

  Future<bool> saveFile(File file) async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save to',
      fileName: p.basename(file.path),
      bytes: await file.readAsBytes(),
      lockParentWindow: true,
    );

    if (isDesktopPlatform) {
      windowManager.show();
    }

    if (outputFile == null) return false;

    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final ext = p.extension(file.path);
      outputFile = p.setExtension(outputFile, ext);
      final result = await EasyWorker.compute<bool, (String, String)>(
        copyFile,
        (file.path, outputFile),
        name: "Copy File",
      );
      return result;
    }
    return true;
  }
}
