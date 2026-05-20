import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:isar_community/isar.dart';

part 'isar_clipboard_item.g.dart';

@Name("ClipboardItem")
@Collection()
class IsarClipboardItem {
  Id isarId = Isar.autoIncrement;

  @Index()
  int? serverId;
  DateTime? lastSynced;
  String? localPath;
  late DateTime created;
  late DateTime modified;
  String? deviceId;
  @Enumerated(EnumType.name)
  @Index()
  late ClipItemType type;
  late String userId;
  String? title;
  String? description;
  @Index()
  DateTime? deletedAt;
  @Index()
  bool encrypted = false;
  String? iv;
  String? encMode;
  // Text related
  String? text;
  String? richData;
  String? url;
  @Enumerated(EnumType.name)
  @Index()
  TextCategory? textCategory;
  // Files related
  String? fileName;
  String? fileMimeType;
  String? fileExtension;
  String? driveFileId;
  int? fileSize;
  String? imgBlurHash;
  // Source Information
  String? sourceUrl;
  String? sourceApp;
  @Index()
  String? sourceId;
  @Enumerated(EnumType.name)
  late PlatformOS os;
  // Collection
  @Index()
  int? serverCollectionId;
  @Index()
  int? collectionId;
  // local only
  bool localOnly = false;
  // Stats
  int copiedCount = 0;
  DateTime? lastCopied;

  /// Short 8-char alphanumeric dedup key for LAN sync.
  @Index()
  String? originId;

  ClipboardItem toDomain() => ClipboardItem(
    id: isarId == Isar.autoIncrement ? null : isarId,
    serverId: serverId,
    lastSynced: lastSynced,
    localPath: localPath,
    created: created,
    modified: modified,
    deviceId: deviceId,
    type: type,
    userId: userId,
    title: title,
    description: description,
    deletedAt: deletedAt,
    encrypted: encrypted,
    iv: iv,
    encMode: encMode,
    text: text,
    richData: richData,
    url: url,
    textCategory: textCategory,
    fileName: fileName,
    fileMimeType: fileMimeType,
    fileExtension: fileExtension,
    driveFileId: driveFileId,
    fileSize: fileSize,
    imgBlurHash: imgBlurHash,
    sourceUrl: sourceUrl,
    sourceApp: sourceApp,
    sourceId: sourceId,
    os: os,
    serverCollectionId: serverCollectionId,
    collectionId: collectionId,
    localOnly: localOnly,
    copiedCount: copiedCount,
    lastCopied: lastCopied,
    originId: originId,
  );

  static IsarClipboardItem fromDomain(ClipboardItem item) => IsarClipboardItem()
    ..isarId = item.id ?? Isar.autoIncrement
    ..serverId = item.serverId
    ..lastSynced = item.lastSynced
    ..localPath = item.localPath
    ..created = item.created
    ..modified = item.modified
    ..deviceId = item.deviceId
    ..type = item.type
    ..userId = item.userId
    ..title = item.title
    ..description = item.description
    ..deletedAt = item.deletedAt
    ..encrypted = item.encrypted
    ..iv = item.iv
    ..encMode = item.encMode
    ..text = item.text
    ..richData = item.richData
    ..url = item.url
    ..textCategory = item.textCategory
    ..fileName = item.fileName
    ..fileMimeType = item.fileMimeType
    ..fileExtension = item.fileExtension
    ..driveFileId = item.driveFileId
    ..fileSize = item.fileSize
    ..imgBlurHash = item.imgBlurHash
    ..sourceUrl = item.sourceUrl
    ..sourceApp = item.sourceApp
    ..sourceId = item.sourceId
    ..os = item.os
    ..serverCollectionId = item.serverCollectionId
    ..collectionId = item.collectionId
    ..localOnly = item.localOnly
    ..copiedCount = item.copiedCount
    ..lastCopied = item.lastCopied
    ..originId = item.originId;
}
