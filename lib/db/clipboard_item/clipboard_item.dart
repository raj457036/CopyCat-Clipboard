import 'dart:io';

import 'package:clipboard/common/logging.dart';
import 'package:clipboard/db/base.dart';
import 'package:clipboard/enums/clip_type.dart';
import 'package:clipboard/enums/platform_os.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;

part 'clipboard_item.freezed.dart';
part 'clipboard_item.g.dart';

const kLocalUserId = "local_user";

@freezed
@Collection(ignore: {'copyWith'})
class ClipboardItem with _$ClipboardItem, IsarIdMixin {
  ClipboardItem._();

  factory ClipboardItem({
    @JsonKey(name: "id", includeToJson: false) int? serverId,
    @JsonKey(includeFromJson: false, includeToJson: false) DateTime? lastSynced,
    @JsonKey(includeFromJson: false, includeToJson: false) String? localPath,
    @JsonKey(name: "created") required DateTime created,
    @JsonKey(name: "modified") required DateTime modified,
    @Enumerated(EnumType.name) required ClipItemType type,
    @Default(kLocalUserId) String userId,
    String? title,
    String? description,
    DateTime? deletedAt,
    @Default(false) bool encrypted,
    // Text related
    String? text,
    String? url,
    // Files related
    String? fileName,
    String? fileMimeType,
    String? fileExtension,
    String? driveFileId,
    int? fileSize, // in KB
    String? imgBlurHash, // only for image

    // Source Information
    String? sourceUrl,
    String? sourceApp,
    @Enumerated(EnumType.name) required PlatformOS os,

    // local only
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool localOnly,

    // Stats
    @Default(0) int copiedCount,
    DateTime? lastCopied,

    // non persistant state
    @ignore
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool? downloading,
    @ignore
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? downloadProgress,
    @ignore
    @JsonKey(includeFromJson: false, includeToJson: false)
    bool? uploading,
    @ignore
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? uploadProgress,
  }) = _ClipboardItem;

  factory ClipboardItem.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemFromJson(json);

  factory ClipboardItem.fromText(
    String text, {
    String? userId,
    String? sourceUrl,
    String? sourceApp,
  }) {
    return ClipboardItem(
      text: text,
      userId: userId ?? kLocalUserId,
      created: DateTime.now().toUtc(),
      modified: DateTime.now().toUtc(),
      type: ClipItemType.text,
      os: currentPlatformOS(),
      sourceUrl: sourceUrl,
      sourceApp: sourceApp,
    );
  }

  factory ClipboardItem.fromMedia(
    String filePath, {
    String? userId,
    String? fileName,
    String? fileMimeType,
    String? fileExtension,
    int? fileSize, // in KB
    String? blurHash, // only for image
    String? sourceUrl,
    String? sourceApp,
  }) {
    return ClipboardItem(
      created: DateTime.now().toUtc(),
      modified: DateTime.now().toUtc(),
      type: ClipItemType.media,
      localPath: filePath,
      userId: userId ?? kLocalUserId,
      fileName: fileName,
      fileExtension: fileExtension,
      fileSize: fileSize,
      fileMimeType: fileMimeType,
      imgBlurHash: blurHash,
      os: currentPlatformOS(),
      sourceUrl: sourceUrl,
      sourceApp: sourceApp,
    );
  }

  factory ClipboardItem.fromFile(
    String filePath, {
    String? userId,
    String? preview,
    String? fileName,
    String? fileMimeType,
    String? fileExtension,
    int? fileSize, // in KB
    String? sourceUrl,
    String? sourceApp,
  }) {
    final basename = p.basename(filePath);

    return ClipboardItem(
      text: preview,
      created: DateTime.now().toUtc(),
      modified: DateTime.now().toUtc(),
      title: fileName ?? basename,
      type: ClipItemType.file,
      localPath: filePath,
      userId: userId ?? kLocalUserId,
      fileName: fileName,
      fileExtension: fileExtension,
      fileSize: fileSize,
      fileMimeType: fileMimeType,
      os: currentPlatformOS(),
      sourceUrl: sourceUrl,
      sourceApp: sourceApp,
    );
  }

  factory ClipboardItem.fromURL(
    Uri uri, {
    String? userId,
    String? title,
    String? description,
    String? sourceUrl,
    String? sourceApp,
  }) {
    return ClipboardItem(
      url: uri.toString(),
      created: DateTime.now().toUtc(),
      modified: DateTime.now().toUtc(),
      title: title,
      description: description,
      type: ClipItemType.url,
      userId: userId ?? kLocalUserId,
      os: currentPlatformOS(),
      sourceUrl: sourceUrl,
      sourceApp: sourceApp,
    );
  }

  /// Removes the associated file.
  Future<void> cleanUp() async {
    try {
      if (localPath != null && type == ClipItemType.file ||
          type == ClipItemType.media) {
        final file = File(localPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      logger.warning("Couldn't delete file! $e");
    }
  }

  bool get isSynced => lastSynced != null;

  bool get inCache =>
      ((type == ClipItemType.file || type == ClipItemType.media) &&
          localPath != null);

  String? get rootDir => type == ClipItemType.file || type == ClipItemType.media
      ? '${type.name}s'
      : null;

  ClipboardItem assignUserId([String? newUserId]) {
    if (newUserId != null && newUserId != userId) {
      return copyWith(userId: userId)..applyId(this);
    }
    return this;
  }

  bool get isSyncing => uploading ?? downloading ?? false;
}
