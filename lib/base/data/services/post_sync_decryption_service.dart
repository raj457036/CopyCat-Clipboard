import 'package:clipboard/base/constants/misc.dart' show kMaxTextClipLength;
import 'package:clipboard/base/domain/sources/clipboard.dart';
import 'package:clipboard/common/logging.dart';
import 'package:injectable/injectable.dart';

/// Runs a one-shot decryption pass over all locally stored encrypted clips.
@lazySingleton
class PostSyncDecryptionService {
  static const _batchSize = 50;
  static const _logger = AppLogger.scoped('PostSyncDecryptionService');

  final ClipboardSource _localSource;

  PostSyncDecryptionService(@Named("local") this._localSource);

  /// Decrypts all locally stored encrypted clips, batch by batch.
  ///
  /// [onProgress] is called after each item with `(decrypted, total)` so the
  /// caller can update a progress indicator incrementally.
  Future<void> decryptAll({
    void Function(int decrypted, int total)? onProgress,
  }) async {
    final total = await _localSource.fetchEncryptedCount();
    if (total == 0) return;

    int decrypted = 0;
    int offset = 0;

    while (true) {
      final page = await _localSource.getList(
        limit: _batchSize,
        offset: offset,
        encrypted: true,
      );

      if (page.results.isEmpty) break;

      for (final item in page.results) {
        // Skip very large text payloads to avoid long blocking decrypt work.
        if ((item.text?.length ?? 0) > kMaxTextClipLength) {
          _logger.d(
            () =>
                "Skipping decryption for id=${item.serverId} due to large text length (${item.text?.length})",
          );
          decrypted++;
          onProgress?.call(decrypted, total);
          continue;
        }

        try {
          final dec = await item.decrypt();
          if (!dec.encrypted) {
            try {
              await _localSource.update(dec);
            } catch (e) {
              _logger.e(() => 'Save failed for id=${item.serverId}: $e');
            }
          }
        } catch (e, st) {
          _logger.e(
            () => 'Decrypt failed for id=${item.serverId}: $e',
            error: e,
            stackTrace: st,
          );
        }
        decrypted++;
        onProgress?.call(decrypted, total);
      }

      if (!page.hasMore) break;
    }
  }
}
