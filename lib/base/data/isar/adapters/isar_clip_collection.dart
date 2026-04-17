import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:isar_community/isar.dart';

part 'isar_clip_collection.g.dart';

@Name("ClipCollection")
@Collection()
class IsarClipCollection {
  Id isarId = Isar.autoIncrement;

  @Index(name: "collection-server-id")
  int? serverId;
  DateTime? lastSynced;
  late DateTime created;
  late DateTime modified;
  late String userId;
  DateTime? deletedAt;
  String? deviceId;
  late String title;
  String? description;
  late String emoji;

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get titleWords => Isar.splitWords(title);

  @Index(type: IndexType.value, caseSensitive: false)
  List<String> get descriptionWords => Isar.splitWords(description ?? '');

  ClipCollection toDomain() => ClipCollection(
        id: isarId == Isar.autoIncrement ? null : isarId,
        serverId: serverId,
        lastSynced: lastSynced,
        created: created,
        modified: modified,
        userId: userId,
        deletedAt: deletedAt,
        deviceId: deviceId,
        title: title,
        description: description,
        emoji: emoji,
      );

  static IsarClipCollection fromDomain(ClipCollection collection) =>
      IsarClipCollection()
        ..isarId = collection.id ?? Isar.autoIncrement
        ..serverId = collection.serverId
        ..lastSynced = collection.lastSynced
        ..created = collection.created
        ..modified = collection.modified
        ..userId = collection.userId
        ..deletedAt = collection.deletedAt
        ..deviceId = collection.deviceId
        ..title = collection.title
        ..description = collection.description
        ..emoji = collection.emoji;
}
