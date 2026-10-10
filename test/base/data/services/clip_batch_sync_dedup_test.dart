import 'package:clipboard/base/data/isar/adapters/isar_clipboard_item.dart';
import 'package:clipboard/base/data/isar/services/isar_clip_batch_sync_service.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:flutter_test/flutter_test.dart';

ClipboardItem _item({
  int? id,
  int? serverId,
  String? originId,
  required DateTime modified,
  DateTime? deletedAt,
  String text = 'test',
  TextCategory? textCategory,
  String? title,
  String? description,
}) {
  return ClipboardItem(
    id: id,
    serverId: serverId,
    originId: originId,
    created: DateTime(2026, 1, 1),
    modified: modified,
    deletedAt: deletedAt,
    type: ClipItemType.text,
    userId: 'user-1',
    os: PlatformOS.macos,
    text: text,
    textCategory: textCategory,
    title: title,
    description: description,
  );
}

void main() {
  group('IsarClipBatchSyncService.collapseBatch', () {
    test('prefers originId as dedup key for new clips', () {
      final t1 = DateTime(2026, 1, 1, 12, 0);
      final t2 = DateTime(2026, 1, 1, 12, 5);

      final itemA = _item(
        id: 1,
        serverId: 100,
        originId: 'origin-abc',
        modified: t1,
        text: 'first version',
      );
      // Same originId, but different or null serverId, newer modified
      final itemB = _item(
        id: 2,
        serverId: null,
        originId: 'origin-abc',
        modified: t2,
        text: 'second version',
      );

      final collapsed = IsarClipBatchSyncService.collapseBatch([itemA, itemB]);

      expect(collapsed.length, 1);
      expect(collapsed.containsKey('origin:origin-abc'), isTrue);
      expect(collapsed['origin:origin-abc']!.text, 'second version');
    });

    test('falls back to serverId when originId is null (legacy clips)', () {
      final t1 = DateTime(2026, 1, 1, 10, 0);
      final t2 = DateTime(2026, 1, 1, 11, 0);

      final legacyA = _item(
        id: 10,
        serverId: 555,
        originId: null,
        modified: t1,
        text: 'legacy v1',
      );
      final legacyB = _item(
        id: 11,
        serverId: 555,
        originId: null,
        modified: t2,
        text: 'legacy v2',
      );

      final collapsed = IsarClipBatchSyncService.collapseBatch([legacyA, legacyB]);

      expect(collapsed.length, 1);
      expect(collapsed.containsKey('server:555'), isTrue);
      expect(collapsed['server:555']!.text, 'legacy v2');
    });

    test('maintains distinct keys for new clip and legacy clip with same numeric ID', () {
      final now = DateTime.now();

      final newClip = _item(
        id: 1,
        serverId: 42,
        originId: 'origin-42',
        modified: now,
        text: 'new clip',
      );
      final legacyClip = _item(
        id: 2,
        serverId: 42,
        originId: null,
        modified: now,
        text: 'legacy clip',
      );

      final collapsed = IsarClipBatchSyncService.collapseBatch([newClip, legacyClip]);

      expect(collapsed.length, 2);
      expect(collapsed.containsKey('origin:origin-42'), isTrue);
      expect(collapsed.containsKey('server:42'), isTrue);
    });

    test('returns empty map for empty batch', () {
      final collapsed = IsarClipBatchSyncService.collapseBatch([]);
      expect(collapsed.isEmpty, isTrue);
    });

    test('preserves latest delete mutation', () {
      final t1 = DateTime(2026, 1, 1, 10, 0);
      final t2 = DateTime(2026, 1, 1, 10, 5);

      final item = _item(
        originId: 'origin-del',
        modified: t1,
        text: 'hello',
      );
      final deletedItem = _item(
        originId: 'origin-del',
        modified: t2,
        deletedAt: t2,
        text: 'hello',
      );

      final collapsed = IsarClipBatchSyncService.collapseBatch([item, deletedItem]);
      expect(collapsed.length, 1);
      expect(collapsed['origin:origin-del']!.deletedAt, isNotNull);
    });
  });

  group('IsarClipBatchSyncService.resolveConflict', () {
    test('incoming newer: preserves non-null metadata from existing', () {
      final t1 = DateTime(2026, 1, 1, 10, 0);
      final t2 = DateTime(2026, 1, 1, 10, 5);
      final now = DateTime(2026, 1, 1, 10, 6);

      final existing = IsarClipboardItem.fromDomain(_item(
        id: 10,
        originId: 'orig-1',
        modified: t1,
        text: 'hello',
        textCategory: TextCategory.phone,
        title: 'OTP Code',
      ));

      final incoming = _item(
        originId: 'orig-1',
        modified: t2,
        text: 'hello updated',
        textCategory: null,
        title: null,
      );

      final result = IsarClipBatchSyncService.resolveConflict(
        incoming: incoming,
        existing: existing,
        now: now,
      );

      expect(result.text, 'hello updated');
      expect(result.textCategory, TextCategory.phone);
      expect(result.title, 'OTP Code');
      expect(result.id, 10);
      expect(result.lastSynced, now);
    });

    test('existing newer or tie: preserves non-null metadata from incoming', () {
      final t1 = DateTime(2026, 1, 1, 10, 5);
      final t2 = DateTime(2026, 1, 1, 10, 0);
      final now = DateTime(2026, 1, 1, 10, 6);

      final existing = IsarClipboardItem.fromDomain(_item(
        id: 20,
        originId: 'orig-2',
        modified: t1,
        text: '206099',
        textCategory: null,
        title: null,
      ));

      final incoming = _item(
        serverId: 3759700,
        originId: 'orig-2',
        modified: t2,
        text: '206099',
        textCategory: TextCategory.phone,
        title: 'OTP Code',
      );

      final result = IsarClipBatchSyncService.resolveConflict(
        incoming: incoming,
        existing: existing,
        now: now,
      );

      expect(result.text, '206099');
      expect(result.textCategory, TextCategory.phone);
      expect(result.title, 'OTP Code');
      expect(result.serverId, 3759700);
      expect(result.id, 20);
      expect(result.lastSynced, now);
    });
  });
}
