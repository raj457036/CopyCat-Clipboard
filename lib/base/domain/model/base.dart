import 'package:freezed_annotation/freezed_annotation.dart';

/// Marker interface for domain models with a local database identifier.
///
/// The [id] field is managed by the persistence layer (Isar, SQLite, etc.).
/// When [id] is null, the model has not been persisted yet.
///
/// Since [id] is a freezed constructor parameter, [copyWith] preserves it
/// automatically — no need for manual ID re-attachment after copying.
abstract mixin class Identifiable {
  @JsonKey(includeToJson: false, includeFromJson: false)
  int? get id;

  bool get isPersisted => id != null;
}
