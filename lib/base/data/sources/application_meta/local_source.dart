import 'package:clipboard/base/data/isar/adapters/isar_application_meta.dart';
import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/domain/sources/application_meta.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@Named('local')
@LazySingleton(as: ApplicationMetaSource)
class LocalApplicationMetaSource implements ApplicationMetaSource {
  final Isar db;

  LocalApplicationMetaSource(this.db);

  IsarCollection<IsarApplicationMeta> get _collection =>
      db.collection<IsarApplicationMeta>();

  @override
  Future<ApplicationMeta?> getBySourceId(String sourceId) async {
    if (sourceId.trim().isEmpty) return null;
    final result = await db.txn(
      () => _collection.filter().sourceIdEqualTo(sourceId).findFirst(),
    );
    return result?.toDomain();
  }

  @override
  Future<Map<String, ApplicationMeta>> getBySourceIds(
    Iterable<String> sourceIds,
  ) async {
    final ids = sourceIds
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
    if (ids.isEmpty) return const {};

    final results = await db.txn(
      () => _collection
          .filter()
          .anyOf(ids, (q, id) => q.sourceIdEqualTo(id))
          .findAll(),
    );

    return {for (final item in results) item.sourceId: item.toDomain()};
  }

  @override
  Future<ApplicationMeta> upsert(ApplicationMeta item) async {
    final existing = await getBySourceId(item.sourceId);
    final toSave = existing == null
        ? item
        : item.copyWith(id: existing.id, created: existing.created);

    final isarItem = IsarApplicationMeta.fromDomain(toSave);
    final id = await db.writeTxn(() => _collection.put(isarItem));
    return toSave.copyWith(id: id);
  }
}
