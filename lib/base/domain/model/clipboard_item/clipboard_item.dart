import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/data/services/encryption.dart';
import 'package:clipboard/base/domain/model/base.dart';
import 'package:clipboard/base/domain/model/json_converters/datetime_converters.dart';
import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:path/path.dart' as p;
import "package:universal_io/io.dart";

part 'clipboard_item.freezed.dart';
part 'clipboard_item.g.dart';

final specialSymbols = RegExp(r"[-_|]");

@freezed
class ClipboardItem with _$ClipboardItem, Identifiable, Syncable {
  ClipboardItem._();

  factory ClipboardItem({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    @JsonKey(name: "id", includeToJson: false) int? serverId,
    @JsonKey(includeFromJson: false, includeToJson: false) DateTime? lastSynced,
    @JsonKey(includeFromJson: false, includeToJson: false) String? localPath,
    @JsonKey(name: "created") @DateTimeConverter() required DateTime created,
    @JsonKey(name: "modified") @DateTimeConverter() required DateTime modified,
    String? deviceId,
    required ClipItemType type,
    @Default(kLocalUserId) String userId,
    String? title,
    String? description,
    @DateTimeConverter() DateTime? deletedAt,
    @Default(false) bool encrypted,
    String? iv,
    @JsonKey(name: "enc_mode") String? encMode,
    // Text related
    String? text,
    String? url,
    TextCategory? textCategory,
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
    required PlatformOS os,

    // Collection
    @JsonKey(name: "collectionId") int? serverCollectionId,
    @JsonKey(includeFromJson: false, includeToJson: false) int? collectionId,

    // local only
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool localOnly,

    // Stats
    @Default(0) int copiedCount,
    @DateTimeConverter() DateTime? lastCopied,

    // non persistant state
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool downloading,
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? downloadProgress,
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool uploading,
    @JsonKey(includeFromJson: false, includeToJson: false)
    double? uploadProgress,
    @JsonKey(includeFromJson: false, includeToJson: false) Failure? failure,

    /// This clip is manually triggered to upload, sync or persist.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(false)
    bool userIntent,
  }) = _ClipboardItem;

  factory ClipboardItem.fromJson(Map<String, dynamic> json) =>
      _$ClipboardItemFromJson(json);

  factory ClipboardItem.fromText(
    String text, {
    String? userId,
    String? sourceUrl,
    String? sourceApp,
    TextCategory? category,
  }) {
    return ClipboardItem(
      text: text,
      userId: userId ?? kLocalUserId,
      created: now(),
      modified: now(),
      type: ClipItemType.text,
      os: currentPlatformOS(),
      sourceUrl: sourceUrl,
      sourceApp: sourceApp,
      textCategory: category,
    );
  }

  factory ClipboardItem.fromMedia(
    String filePath, {
    String? userId,
    String? fileName,
    String? fileMimeType,
    String? fileExtension,
    int? fileSize, // in Bytes
    String? blurHash, // only for image
    String? sourceUrl,
    String? sourceApp,
  }) {
    return ClipboardItem(
      created: now(),
      modified: now(),
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
      created: now(),
      modified: now(),
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
    final url = Uri.decodeFull(cleanUpString(uri.toString())!);
    return ClipboardItem(
      url: url,
      created: now(),
      modified: now(),
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
      logger.w("Couldn't delete file! $e");
    }
  }

  bool get isSynced => lastSynced != null;

  bool get isTextType => type == ClipItemType.text || type == ClipItemType.url;

  bool get inCache =>
      ((type == ClipItemType.file || type == ClipItemType.media) &&
          localPath != null) ||
      type == ClipItemType.text ||
      type == ClipItemType.url;

  String? get rootDir => type == ClipItemType.file || type == ClipItemType.media
      ? '${type.name}s'
      : null;

  ClipboardItem assignUserId([String? newUserId]) {
    if (newUserId != null && newUserId != userId) {
      return copyWith(userId: newUserId);
    }
    return this;
  }

  Future<ClipboardItem> encrypt() async {
    final encrypter = EncryptionWorker.instance;
    if (!encrypter.isRunning || !encrypter.isEncryptionActive || encrypted) {
      return this;
    }

    if (type == ClipItemType.text && text != null && text!.trim().isNotEmpty) {
      final String mode =
          encrypter.useNonce ? EncryptionMode.gcm : EncryptionMode.cfb;
      final String? itemIV = encrypter.useNonce ? encrypter.generateIV(12) : null;
      final encText =
          await encrypter.encrypt(text!, customIV: itemIV, mode: mode);
      return copyWith(encrypted: true, text: encText, iv: itemIV, encMode: mode);
    }

    if (type == ClipItemType.url && url != null && url!.trim().isNotEmpty) {
      final String mode =
          encrypter.useNonce ? EncryptionMode.gcm : EncryptionMode.cfb;
      final String? itemIV = encrypter.useNonce ? encrypter.generateIV(12) : null;
      final encUrl = await encrypter.encrypt(url!, customIV: itemIV, mode: mode);
      return copyWith(encrypted: true, url: encUrl, iv: itemIV, encMode: mode);
    }
    return this;
  }

  Future<ClipboardItem> decrypt({bool throwException = false}) async {
    if (!encrypted) return this;

    final encrypter = EncryptionWorker.instance;
    await encrypter.waitUntilReady();

    if (!encrypter.isRunning || !encrypter.isDecryptionActive) {
      if (throwException) {
        throw DecryptionException("Encrypter Worker not running!");
      }
      return this;
    }

    if (type == ClipItemType.text && text != null) {
      final decText = await encrypter.decrypt(text!, customIV: iv, mode: encMode);
      return copyWith(encrypted: false, text: decText);
    }

    if (type == ClipItemType.url && url != null) {
      final decUrl = await encrypter.decrypt(url!, customIV: iv, mode: encMode);
      return copyWith(encrypted: false, url: decUrl);
    }
    return this;
  }

  ClipboardItem syncDone([Failure? failure]) {
    return copyWith(downloading: false, uploading: false, failure: failure);
  }

  bool get needDownload =>
      (type == ClipItemType.file || type == ClipItemType.media) &&
      serverId != null &&
      driveFileId != null &&
      localPath == null;

  bool get isSyncing => (uploading || downloading) && driveFileId == null;

  String? get displayTitle {
    if (title != null && title!.isNotEmpty) return title;
    if (fileName != null && fileName!.isNotEmpty) return fileName;
    return null;
  }

  bool get hasCollection =>
      (serverCollectionId != null || collectionId != null) && !encrypted;

  @override
  Syncable copyWithSyncMetadata({int? id, DateTime? lastSynced}) {
    return copyWith(
      id: id ?? this.id,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }
}
