import 'package:clipboard/base/domain/model/cloud_file_id/cloud_file_id.dart';
import 'package:clipboard/base/domain/repositories/webdav_credential.dart';
import 'package:clipboard/base/domain/services/file_cloud_service.dart';
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/sort.dart';
import 'package:clipboard/common/logging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class WebDavCleanupService {
  static const _logger = AppLogger.scoped('WebDavCleanupService');

  final WebDavCredentialRepository _credentialRepo;
  final FileCloudService _webdavService;
  final ClipboardSource _localSource;

  WebDavCleanupService(
    this._credentialRepo,
    @Named('webdav') this._webdavService,
    @Named('local') this._localSource,
  );

  /// Cleans WebDAV files older than 30 days of inactivity if enabled in config.
  /// Clips in collections or locked are always protected.
  Future<void> runCleanupIfEligible() async {
    try {
      final configResult = await _credentialRepo.getConfig();
      final config = configResult.fold((_) => null, (c) => c);

      if (config == null ||
          !config.autoCleanInactiveFiles ||
          config.password.isEmpty) {
        return;
      }

      final isAvailable = await _webdavService.isAvailable;
      if (!isAvailable) {
        _logger.d(() => 'WebDAV is not reachable, skipping inactive cleanup');
        return;
      }

      final cutoffDate = DateTime.now().subtract(const Duration(days: 30));
      int offset = 0;
      const limit = 50;

      while (true) {
        final page = await _localSource.getList(
          limit: limit,
          offset: offset,
          types: {ClipItemType.file, ClipItemType.media},
          sortBy: ClipboardSortKey.modified,
          order: SortOrder.asc,
        );

        if (page.results.isEmpty) break;

        for (final item in page.results) {
          // If modified is after cutoffDate (items sorted asc), we can finish
          if (item.modified.isAfter(cutoffDate)) {
            return;
          }

          // Protected checks: part of collection or locked
          if (item.collectionId != null ||
              item.serverCollectionId != null ||
              item.locked) {
            continue;
          }

          final driveFileId = item.driveFileId;
          if (driveFileId == null ||
              !driveFileId.startsWith(CloudStorageType.webdavPrefix)) {
            continue;
          }

          _logger.i(() => 'Deleting inactive WebDAV file for item ${item.id}');
          final deleteResult = await _webdavService.delete(item);

          await deleteResult.fold(
            (failure) async => _logger.w(
              () =>
                  'Failed to delete WebDAV file for item ${item.id}: $failure',
            ),
            (_) async {
              // Update local item using repository source abstraction
              await _localSource.update(item.copyWith(driveFileId: null));
              _logger.d(() => 'Cleared WebDAV driveFileId for item ${item.id}');
            },
          );
        }

        if (!page.hasMore) break;
        offset += limit;
      }
    } catch (e) {
      _logger.e(() => 'Error during WebDAV inactive files cleanup: $e');
    }
  }
}
