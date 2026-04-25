import 'package:clipboard/base/domain/model/application_meta/application_meta.dart';
import 'package:clipboard/base/domain/repositories/application_meta.dart';
import 'package:clipboard/base/domain/sources/application_meta.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: ApplicationMetaRepository)
class ApplicationMetaRepositoryImpl implements ApplicationMetaRepository {
  final ApplicationMetaSource local;

  ApplicationMetaRepositoryImpl(@Named('local') this.local);

  @override
  FailureOr<ApplicationMeta?> getBySourceId(String sourceId) async {
    try {
      final item = await local.getBySourceId(sourceId);
      return Right(item);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<Map<String, ApplicationMeta>> getBySourceIds(
    Iterable<String> sourceIds,
  ) async {
    try {
      final result = await local.getBySourceIds(sourceIds);
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<ApplicationMeta> upsert(ApplicationMeta item) async {
    try {
      final saved = await local.upsert(item);
      return Right(saved);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
