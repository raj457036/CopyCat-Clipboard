import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';

abstract class ApplicationMetaSource {
  Future<ApplicationMeta?> getBySourceId(String sourceId);
  Future<ApplicationMeta> upsert(ApplicationMeta item);
  Future<Map<String, ApplicationMeta>> getBySourceIds(
    Iterable<String> sourceIds,
  );
}
