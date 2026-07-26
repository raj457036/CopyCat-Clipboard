import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:drift/drift.dart';

@DataClassName('DriftClipboardItemEntry')
class DriftClipboardItemTable extends Table {
  @override
  String get tableName => 'clipboard_item';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get serverId => integer().nullable()();
  DateTimeColumn get lastSynced => dateTime().nullable()();
  TextColumn get localPath => text().nullable()();
  DateTimeColumn get created => dateTime()();
  DateTimeColumn get modified => dateTime()();
  TextColumn get deviceId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get userId => text()();
  TextColumn get title => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
  BoolColumn get locked => boolean().withDefault(const Constant(false))();
  BoolColumn get encrypted => boolean().withDefault(const Constant(false))();
  TextColumn get iv => text().nullable()();
  TextColumn get encMode => text().nullable()();
  TextColumn get textContent => text().named('text').nullable()();
  TextColumn get richData => text().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get textCategory => text().nullable()();
  TextColumn get linkPreviewTitle => text().nullable()();
  TextColumn get linkPreviewDescription => text().nullable()();
  TextColumn get linkPreviewImageUrl => text().nullable()();
  TextColumn get fileName => text().nullable()();
  TextColumn get fileMimeType => text().nullable()();
  TextColumn get fileExtension => text().nullable()();
  TextColumn get driveFileId => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get imgBlurHash => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
  TextColumn get sourceApp => text().nullable()();
  TextColumn get sourceId => text().nullable()();
  TextColumn get os => text()();
  IntColumn get serverCollectionId => integer().nullable()();
  IntColumn get collectionId => integer().nullable()();
  BoolColumn get localOnly => boolean().withDefault(const Constant(false))();
  IntColumn get copiedCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCopied => dateTime().nullable()();
  TextColumn get originId => text().nullable()();
  TextColumn get searchTokens => text().nullable()();

  static ClipboardItem toDomain(DriftClipboardItemEntry entry) => ClipboardItem(
        id: entry.id,
        serverId: entry.serverId,
        lastSynced: entry.lastSynced,
        localPath: entry.localPath,
        created: entry.created,
        modified: entry.modified,
        deviceId: entry.deviceId,
        type: ClipItemType.values.firstWhere(
          (e) => e.name == entry.type,
          orElse: () => ClipItemType.text,
        ),
        userId: entry.userId,
        title: entry.title,
        description: entry.description,
        deletedAt: entry.deletedAt,
        locked: entry.locked,
        encrypted: entry.encrypted,
        iv: entry.iv,
        encMode: entry.encMode,
        text: entry.textContent,
        richData: entry.richData,
        url: entry.url,
        textCategory: entry.textCategory != null
            ? TextCategory.values.firstWhere(
                (e) => e.name == entry.textCategory,
                orElse: () => TextCategory.struct,
              )
            : null,
        linkPreviewTitle: entry.linkPreviewTitle,
        linkPreviewDescription: entry.linkPreviewDescription,
        linkPreviewImageUrl: entry.linkPreviewImageUrl,
        fileName: entry.fileName,
        fileMimeType: entry.fileMimeType,
        fileExtension: entry.fileExtension,
        driveFileId: entry.driveFileId,
        fileSize: entry.fileSize,
        imgBlurHash: entry.imgBlurHash,
        sourceUrl: entry.sourceUrl,
        sourceApp: entry.sourceApp,
        sourceId: entry.sourceId,
        os: PlatformOS.values.firstWhere(
          (e) => e.name == entry.os,
          orElse: () => PlatformOS.macos,
        ),
        serverCollectionId: entry.serverCollectionId,
        collectionId: entry.collectionId,
        localOnly: entry.localOnly,
        copiedCount: entry.copiedCount,
        lastCopied: entry.lastCopied,
        originId: entry.originId,
      );

  static DriftClipboardItemTableCompanion fromDomain(ClipboardItem item) => DriftClipboardItemTableCompanion.insert(
        id: item.id != null ? Value(item.id!) : const Value.absent(),
        serverId: Value(item.serverId),
        lastSynced: Value(item.lastSynced),
        localPath: Value(item.localPath),
        created: item.created,
        modified: item.modified,
        deviceId: Value(item.deviceId),
        type: item.type.name,
        userId: item.userId,
        title: Value(item.title),
        description: Value(item.description),
        deletedAt: Value(item.deletedAt),
        locked: Value(item.locked),
        encrypted: Value(item.encrypted),
        iv: Value(item.iv),
        encMode: Value(item.encMode),
        textContent: Value(item.text),
        richData: Value(item.richData),
        url: Value(item.url),
        textCategory: Value(item.textCategory?.name),
        linkPreviewTitle: Value(item.linkPreviewTitle),
        linkPreviewDescription: Value(item.linkPreviewDescription),
        linkPreviewImageUrl: Value(item.linkPreviewImageUrl),
        fileName: Value(item.fileName),
        fileMimeType: Value(item.fileMimeType),
        fileExtension: Value(item.fileExtension),
        driveFileId: Value(item.driveFileId),
        fileSize: Value(item.fileSize),
        imgBlurHash: Value(item.imgBlurHash),
        sourceUrl: Value(item.sourceUrl),
        sourceApp: Value(item.sourceApp),
        sourceId: Value(item.sourceId),
        os: item.os.name,
        serverCollectionId: Value(item.serverCollectionId),
        collectionId: Value(item.collectionId),
        localOnly: Value(item.localOnly),
        copiedCount: Value(item.copiedCount),
        lastCopied: Value(item.lastCopied),
        originId: Value(item.originId),
      );
}
