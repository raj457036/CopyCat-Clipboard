import 'package:clipboard/base/enums/clip_type.dart';
import 'package:crypto/crypto.dart' show Digest;
import 'package:equatable/equatable.dart';
import 'package:path/path.dart' as p;
import 'package:universal_io/io.dart';

/// Lightweight snapshot of a clipboard event used for duplicate detection.
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
  );

  factory ClipItem.file({
    required File file,
    String? textPreview,
    String? fileName,
    required String mimeType,
    required int fileSize,
    Uri? originalPathUri,
  }) => ClipItem(
    file: file,
    fileName: fileName,
    uri: originalPathUri,
    text: textPreview,
    type: ClipItemType.file,
    fileMimeType: mimeType,
    fileExtension: p.extension(file.path),
    fileSize: fileSize,
  );
}
