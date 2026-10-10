import 'package:clipboard/base/data/isar/adapters/isar_app_config.dart';
import 'package:clipboard/base/domain/model/app_config/appconfig.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ClipboardFeedbackMode JSON serialization & deserialization', () {
    test('defaults to copyAndSync when null or omitted in json', () {
      final config = AppConfig.fromJson(<String, dynamic>{});
      expect(config.clipboardFeedbackMode, equals(ClipboardFeedbackMode.copyAndSync));
    });

    test('migrates legacy "toast" string to copyAndSync', () {
      final config = AppConfig.fromJson(<String, dynamic>{
        'clipboardFeedbackMode': 'toast',
      });
      expect(config.clipboardFeedbackMode, equals(ClipboardFeedbackMode.copyAndSync));
    });

    test('deserializes all modern modes accurately', () {
      final disabled = AppConfig.fromJson(<String, dynamic>{
        'clipboardFeedbackMode': 'disabled',
      });
      expect(disabled.clipboardFeedbackMode, equals(ClipboardFeedbackMode.disabled));

      final copyOnly = AppConfig.fromJson(<String, dynamic>{
        'clipboardFeedbackMode': 'copyOnly',
      });
      expect(copyOnly.clipboardFeedbackMode, equals(ClipboardFeedbackMode.copyOnly));

      final syncOnly = AppConfig.fromJson(<String, dynamic>{
        'clipboardFeedbackMode': 'syncOnly',
      });
      expect(syncOnly.clipboardFeedbackMode, equals(ClipboardFeedbackMode.syncOnly));

      final copyAndSync = AppConfig.fromJson(<String, dynamic>{
        'clipboardFeedbackMode': 'copyAndSync',
      });
      expect(copyAndSync.clipboardFeedbackMode, equals(ClipboardFeedbackMode.copyAndSync));
    });

    test('serializes mode names correctly to JSON', () {
      final configCopyOnly = AppConfig(clipboardFeedbackMode: ClipboardFeedbackMode.copyOnly);
      expect(configCopyOnly.toJson()['clipboardFeedbackMode'], equals('copyOnly'));

      final configSyncOnly = AppConfig(clipboardFeedbackMode: ClipboardFeedbackMode.syncOnly);
      expect(configSyncOnly.toJson()['clipboardFeedbackMode'], equals('syncOnly'));

      final configCopyAndSync = AppConfig(clipboardFeedbackMode: ClipboardFeedbackMode.copyAndSync);
      expect(configCopyAndSync.toJson()['clipboardFeedbackMode'], equals('copyAndSync'));

      final configDisabled = AppConfig(clipboardFeedbackMode: ClipboardFeedbackMode.disabled);
      expect(configDisabled.toJson()['clipboardFeedbackMode'], equals('disabled'));
    });
  });

  group('IsarAppConfig legacy toast migration', () {
    test('toDomain maps legacy toast to copyAndSync', () {
      final isarConfig = IsarAppConfig()
        // ignore: deprecated_member_use_from_same_package
        ..clipboardFeedbackMode = ClipboardFeedbackMode.toast;

      final domain = isarConfig.toDomain();
      expect(domain.clipboardFeedbackMode, equals(ClipboardFeedbackMode.copyAndSync));
    });

    test('fromDomain maps legacy toast to copyAndSync', () {
      final domain = AppConfig(
        // ignore: deprecated_member_use_from_same_package
        clipboardFeedbackMode: ClipboardFeedbackMode.toast,
      );

      final isarConfig = IsarAppConfig.fromDomain(domain);
      expect(isarConfig.clipboardFeedbackMode, equals(ClipboardFeedbackMode.copyAndSync));
    });

    test('preserves modern feedback modes across Isar conversion', () {
      for (final mode in [
        ClipboardFeedbackMode.disabled,
        ClipboardFeedbackMode.copyOnly,
        ClipboardFeedbackMode.syncOnly,
        ClipboardFeedbackMode.copyAndSync,
      ]) {
        final domain = AppConfig(clipboardFeedbackMode: mode);
        final isarConfig = IsarAppConfig.fromDomain(domain);
        expect(isarConfig.clipboardFeedbackMode, equals(mode));
        expect(isarConfig.toDomain().clipboardFeedbackMode, equals(mode));
      }
    });
  });

  group('Clipboard feedback mode filtering logic', () {
    bool isCopyFeedbackEnabled(ClipboardFeedbackMode mode) {
      return mode == ClipboardFeedbackMode.copyOnly ||
          mode == ClipboardFeedbackMode.copyAndSync ||
          // ignore: deprecated_member_use_from_same_package
          mode == ClipboardFeedbackMode.toast;
    }

    bool isSyncFeedbackEnabled(ClipboardFeedbackMode mode) {
      return mode == ClipboardFeedbackMode.syncOnly ||
          mode == ClipboardFeedbackMode.copyAndSync ||
          // ignore: deprecated_member_use_from_same_package
          mode == ClipboardFeedbackMode.toast;
    }

    test('validates copy feedback activation per mode', () {
      expect(isCopyFeedbackEnabled(ClipboardFeedbackMode.disabled), isFalse);
      expect(isCopyFeedbackEnabled(ClipboardFeedbackMode.syncOnly), isFalse);
      expect(isCopyFeedbackEnabled(ClipboardFeedbackMode.copyOnly), isTrue);
      expect(isCopyFeedbackEnabled(ClipboardFeedbackMode.copyAndSync), isTrue);
      // ignore: deprecated_member_use_from_same_package
      expect(isCopyFeedbackEnabled(ClipboardFeedbackMode.toast), isTrue);
    });

    test('validates sync feedback activation per mode', () {
      expect(isSyncFeedbackEnabled(ClipboardFeedbackMode.disabled), isFalse);
      expect(isSyncFeedbackEnabled(ClipboardFeedbackMode.copyOnly), isFalse);
      expect(isSyncFeedbackEnabled(ClipboardFeedbackMode.syncOnly), isTrue);
      expect(isSyncFeedbackEnabled(ClipboardFeedbackMode.copyAndSync), isTrue);
      // ignore: deprecated_member_use_from_same_package
      expect(isSyncFeedbackEnabled(ClipboardFeedbackMode.toast), isTrue);
    });
  });
}
