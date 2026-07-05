import 'package:clipboard/base/constants/strings/strings.dart';
import 'package:clipboard/base/domain/model/base.dart';
import 'package:clipboard/base/domain/model/json_converters/datetime_converters.dart';
import 'package:clipboard/base/domain/model/syncable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'clipcollection.freezed.dart';
part 'clipcollection.g.dart';

@freezed
abstract class ClipCollection with _$ClipCollection, Identifiable, Syncable {
  ClipCollection._();

  factory ClipCollection({
    @JsonKey(includeToJson: false, includeFromJson: false) int? id,
    @JsonKey(name: "id", includeToJson: false) int? serverId,
    @JsonKey(includeFromJson: false, includeToJson: false) DateTime? lastSynced,
    @JsonKey(name: "created") @DateTimeConverter() required DateTime created,
    @JsonKey(name: "modified") @DateTimeConverter() required DateTime modified,
    @Default(kLocalUserId) String userId,
    @DateTimeConverter() DateTime? deletedAt,
    String? deviceId,
    required String title,
    String? description,
    required String emoji,
  }) = _ClipCollection;

  factory ClipCollection.fromJson(Map<String, dynamic> json) =>
      _$ClipCollectionFromJson(json);

  @override
  Syncable copyWithSyncMetadata({int? id, DateTime? lastSynced}) {
    return copyWith(
      id: id ?? this.id,
      lastSynced: lastSynced ?? this.lastSynced,
    );
  }
}
