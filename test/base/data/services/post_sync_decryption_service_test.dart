import 'package:clipboard/base/constants/misc.dart';
import 'package:clipboard/base/data/services/post_sync_decryption_service.dart';
import 'package:clipboard/base/domain/model/clipboard_item/clipboard_item.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/base/enums/platform_os.dart';
import 'package:clipboard/utils/utility.dart';
import 'package:flutter_test/flutter_test.dart';

ClipboardItem _createItem({
  required int id,
  bool encrypted = false,
  bool locked = false,
  String? text,
}) {
  return ClipboardItem(
    id: id,
    serverId: id,
    created: systemTime(),
    modified: systemTime(),
    type: ClipItemType.text,
    userId: 'user-1',
    os: PlatformOS.macos,
    encrypted: encrypted,
    locked: locked,
    text: text ?? 'sample text',
  );
}

void main() {
  test(
    'decryptBatch returns items untouched if none are encrypted',
    () async {
      final items = [
        _createItem(id: 1, encrypted: false, text: 'Hello'),
        _createItem(id: 2, encrypted: false, text: 'World'),
      ];

      final result = await PostSyncDecryptionService.decryptBatch(items);

      expect(result.length, 2);
      expect(result[0].text, 'Hello');
      expect(result[1].text, 'World');
    },
  );

  test(
    'decryptBatch skips locked or oversized text items when worker is inactive',
    () async {
      final largeText = 'A' * (kMaxTextClipLength + 10);
      final items = [
        _createItem(id: 1, encrypted: true, locked: true, text: 'enc1'),
        _createItem(id: 2, encrypted: true, text: largeText),
      ];

      final result = await PostSyncDecryptionService.decryptBatch(items);

      expect(result.length, 2);
      expect(result[0].locked, true);
      expect(result[0].encrypted, true);
      expect(result[1].text, largeText);
      expect(result[1].encrypted, true);
    },
  );
}
