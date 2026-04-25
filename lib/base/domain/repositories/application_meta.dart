import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/common/failure.dart';

abstract class ApplicationMetaRepository {
  FailureOr<ApplicationMeta?> getBySourceId(String sourceId);
  FailureOr<ApplicationMeta> upsert(ApplicationMeta item);
  FailureOr<Map<String, ApplicationMeta>> getBySourceIds(
    Iterable<String> sourceIds,
  );
}
