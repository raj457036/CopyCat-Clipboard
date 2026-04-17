import 'package:clipboard/base/data/isar/adapters/isar_app_config.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/repositories/app_config.dart';
import 'package:clipboard/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';

@LazySingleton(as: AppConfigRepository)
class AppConfigRepositoryImpl implements AppConfigRepository {
  final Isar db;
  final _fixedId = 1;

  AppConfigRepositoryImpl(this.db);

  IsarCollection<IsarAppConfig> get _collection =>
      db.collection<IsarAppConfig>();

  Future<AppConfig> create() async {
    final appConfig = AppConfig(id: _fixedId);
    final isarConfig = IsarAppConfig.fromDomain(appConfig);
    await db.writeTxn(() async => await _collection.put(isarConfig));
    return appConfig;
  }

  @override
  FailureOr<AppConfig> get() async {
    try {
      final result = await _collection.get(_fixedId);
      if (result == null) {
        final created = await create();
        return Right(created);
      }
      return Right(result.toDomain());
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<AppConfig> update(AppConfig config) async {
    try {
      final isarConfig = IsarAppConfig.fromDomain(
        config.copyWith(id: config.id ?? _fixedId),
      );
      await db.writeTxn(() async => await _collection.put(isarConfig));
      return Right(config);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
