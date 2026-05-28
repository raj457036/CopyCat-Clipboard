import 'dart:convert' show utf8;

import 'package:clipboard/base/enums/clip_type.dart';
import 'package:crypto/crypto.dart' show sha256;
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

/// Transient in-memory representation of a clipboard item built during
/// capture. Not persisted directly — converted to [ClipboardItem] by the
/// offline-persistence cubit.
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

  /// JSON payload containing rich text representations keyed by MIME type.
  String? richData;

  final bool isDuplicate;

  /// SHA-256 hex digest of the raw file/media bytes, precomputed during
  /// capture. Null for text and URL clips (their hash is derived lazily from
  /// their string fields via [contentHash]).
  final String? contentDigest;

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
    this.richData,
    this.blurHash,
    this.isDuplicate = false,
    this.contentDigest,
  });

  bool get isImage => fileMimeType?.startsWith("image") ?? false;
  bool get isVideo => fileMimeType?.startsWith("video") ?? false;
  bool get isAudio => fileMimeType?.startsWith("audio") ?? false;
  bool get isText => type == ClipItemType.text;
  bool get isUri => type == ClipItemType.url;
  bool get isFile => type == ClipItemType.file;
  bool get isTextSubType =>
      type == ClipItemType.text || type == ClipItemType.url;

  /// SHA-256 of the canonical content.
  /// For text/URL: computed lazily from the stored string.
  /// For file/media: returns the precomputed [contentDigest] from raw bytes.
  String? get contentHash {
    switch (type) {
      case ClipItemType.text:
        final t = text?.trim();
        if (t == null || t.isEmpty) return null;
        return sha256.convert(utf8.encode(t)).toString();
      case ClipItemType.url:
        final u = uri?.toString().trim();
        if (u == null || u.isEmpty) return null;
        return sha256.convert(utf8.encode(u)).toString();
      case ClipItemType.file:
      case ClipItemType.media:
        return contentDigest;
    }
  }

  Future<void> cleanup() async {
    if (file != null && await file!.exists()) {
      await file!.delete();
    }
  }

  factory ClipItem.duplicate({String? contentDigest}) => ClipItem(
    type: ClipItemType.text,
    file: null,
    fileName: null,
    text: null,
    uri: null,
    fileMimeType: null,
    fileExtension: null,
    fileSize: null,
    isDuplicate: true,
    contentDigest: contentDigest,
  );

  factory ClipItem.text({required String text, TextCategory? textCategory}) =>
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

  factory ClipItem.uri({required Uri uri}) => ClipItem(
    file: null,
    fileName: null,
    uri: uri,
    text: null,
    type: ClipItemType.url,
    fileMimeType: null,
    fileExtension: null,
    fileSize: null,
  );

  factory ClipItem.mediaFile({
    required File file,
    String? fileName,
    required String mimeType,
    required int fileSize,
    String? blurHash,
    Uri? originalPathUri,
    String? contentDigest,
  }) => ClipItem(
    fileName: fileName,
    file: file,
    uri: originalPathUri,
    text: null,
    type: ClipItemType.media,
    fileMimeType: mimeType,
    fileExtension: p.extension(file.path),
    fileSize: fileSize,
    blurHash: blurHash,
    contentDigest: contentDigest,
  );

  factory ClipItem.file({
    required File file,
    String? textPreview,
    String? fileName,
    required String mimeType,
    required int fileSize,
    Uri? originalPathUri,
    String? contentDigest,
  }) => ClipItem(
    file: file,
    fileName: fileName,
    uri: originalPathUri,
    text: textPreview,
    type: ClipItemType.file,
    fileMimeType: mimeType,
    fileExtension: p.extension(file.path),
    fileSize: fileSize,
    contentDigest: contentDigest,
  );
}
