import 'package:clipboard/base/domain/model/clip_collection/clipcollection.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/domain/repositories/sync_clipboard.dart';
import 'package:clipboard/base/domain/sources/sync_clipboard.dart';
import 'package:clipboard/common/failure.dart';
import 'package:clipboard/common/paginated_results.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: SyncRepository)
class SyncRepositoryImpl implements SyncRepository {
  final SyncClipboardSource source;

  SyncRepositoryImpl(@Named("remote") this.source);

  @override
  FailureOr<PaginatedResult<ClipboardItem>> getLatestClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async {
    try {
      final result = await source.getLatestClipboardItems(
        limit: limit,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
      );

      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> getLatestCollectionClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async {
    try {
      final result = await source.getLatestCollectionClipboardItems(
        limit: limit,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
      );

      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipCollection>> getLatestClipCollections({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
  }) async {
    try {
      final result = await source.getLatestClipCollections(
        limit: limit,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipboardItem>> getDeletedClipboardItems({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    try {
      final result = await source.getDeletedClipboardItems(
        limit: limit,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
        lastSynced: lastSynced,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }

  @override
  FailureOr<PaginatedResult<ClipCollection>> getDeletedClipCollections({
    int limit = 100,
    DateTime? lastModified,
    String? excludeDeviceId,
    DateTime? lastSynced,
  }) async {
    try {
      final result = await source.getDeletedClipCollections(
        limit: limit,
        lastModified: lastModified,
        excludeDeviceId: excludeDeviceId,
        lastSynced: lastSynced,
      );
      return Right(result);
    } catch (e) {
      return Left(Failure.fromException(e));
    }
  }
}
