import 'package:clipboard/base/data/drift/drift_database.dart';
import 'package:clipboard/base/data/drift/tables/drift_app_config.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:clipboard/base/domain/repositories/app_config.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/logging.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@Named('drift')
@LazySingleton(as: AppConfigRepository)
class DriftAppConfigRepository implements AppConfigRepository {
  static const logger = AppLogger.scoped('Drift AppConfig Repository');
  final AppDatabase db;
  final _fixedId = 1;

  DriftAppConfigRepository(this.db);

  Future<AppConfig> create() async {
    final appConfig = AppConfig(id: _fixedId);
    final companion = DriftAppConfigTable.fromDomain(appConfig);
    await db.into(db.driftAppConfigTable).insertOnConflictUpdate(companion);
    return appConfig;
  }

  @override
  FailureOr<AppConfig> get() async {
    try {
      final query = db.select(db.driftAppConfigTable)
        ..where((tbl) => tbl.id.equals(_fixedId));
      final result = await query.getSingleOrNull();

      if (result == null) {
        logger.w(() => '⚠️ AppConfig not found in Drift DB, creating default config');
        final created = await create();
        return Right(created);
      }
      logger.d(() => '✅ AppConfig retrieved from Drift DB: $result');
      return Right(DriftAppConfigTable.toDomain(result));
    } catch (e) {
      logger.e(() => 'Failed to get AppConfig from Drift DB - $e');
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<AppConfig> update(AppConfig config) async {
    try {
      final targetConfig = config.copyWith(id: config.id ?? _fixedId);
      final companion = DriftAppConfigTable.fromDomain(targetConfig);

      logger.d(() => '⏱️ Updating AppConfig in Drift DB: $targetConfig');
      await db.into(db.driftAppConfigTable).insertOnConflictUpdate(companion);
      logger.d(() => '✅ AppConfig updated successfully');
      return Right(targetConfig);
    } catch (e) {
      logger.e(() => 'Failed to update AppConfig in Drift DB - $e');
      return Left(Failure.fromException(e));
    }
  }
}
