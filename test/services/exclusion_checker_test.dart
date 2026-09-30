import 'dart:io';

import 'package:clipboard/base/data/services/clipboard/clip_models.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_checker.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_result.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/utils/clipboard_feedback_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focus_window/platform/activity_info.dart';

void main() {
  group('ExclusionChecker checkClip & checkActivity', () {
    late ExclusionChecker checker;

    setUp(() {
      checker = ExclusionChecker(
        ExclusionRules(
          phone: true,
          email: true,
          creditCard: true,
          sensitiveUrls: true,
          passwordManager: true,
          patterns: [r'^SECRET_.*'],
          apps: [
            AppInfo(name: 'CustomRestrictedApp', identifier: 'com.example.restricted'),
          ],
        ),
      );
    });

    test('allows regular safe text clips', () {
      final clip = ClipItem.text(text: 'Hello world this is safe text');
      final result = checker.checkClip(ExclusionCheckParams(clip: clip));

      expect(result.isAllowed, isTrue);
      expect(result.reason, isNull);
    });

    test('detects and excludes phone numbers', () {
      final clip = ClipItem.text(text: 'Call me at 555-123-4567');
      final result = checker.checkClip(ExclusionCheckParams(clip: clip));

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.phone);
    });

    test('detects and excludes email addresses', () {
      final clip = ClipItem.text(text: 'Send to test.user@example.com');
      final result = checker.checkClip(ExclusionCheckParams(clip: clip));

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.email);
    });

    test('detects and excludes credit cards', () {
      final clip = ClipItem.text(text: 'Card: 1234 5678 9012 3456');
      final result = checker.checkClip(ExclusionCheckParams(clip: clip));

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.creditCard);
    });

    test('detects and excludes custom regex patterns', () {
      final clip = ClipItem.text(text: 'SECRET_API_KEY_123');
      final result = checker.checkClip(ExclusionCheckParams(clip: clip));

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.pattern);
    });

    test('excludes text from sensitive apps like 1Password', () {
      final clip = ClipItem.text(text: 'Some random text');
      const activity = ActivityInfo(
        pid: 1234,
        app: '1Password',
        identifier: 'com.agilebits.onepassword',
        appFileName: '1Password.app',
        appFilePath: '/Applications/1Password.app',
        title: '1Password - Vault',
        url: '',
        document: '',
      );

      final result = checker.checkClip(
        ExclusionCheckParams(clip: clip, activity: activity),
      );

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.excludedApp);
      expect(result.matchedDetail, '1Password');
    });

    test('excludes non-text clips (e.g. image/file) if app is restricted', () {
      final clip = ClipItem.file(
        file: File('screenshot.png'),
        mimeType: 'image/png',
        fileSize: 1024,
      );
      const activity = ActivityInfo(
        pid: 1234,
        app: '1Password',
        identifier: 'com.agilebits.onepassword',
        appFileName: '1Password.app',
        appFilePath: '/Applications/1Password.app',
        title: '1Password - Vault',
        url: '',
        document: '',
      );

      final result = checker.checkClip(
        ExclusionCheckParams(clip: clip, activity: activity),
      );

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.excludedApp);
      expect(result.matchedDetail, '1Password');
    });

    test('excludes clips when custom app rule matches', () {
      final clip = ClipItem.text(text: 'Data from restricted app');
      const activity = ActivityInfo(
        pid: 1234,
        app: 'CustomRestrictedApp',
        identifier: 'com.example.restricted',
        appFileName: 'CustomRestrictedApp.app',
        appFilePath: '/Applications/CustomRestrictedApp.app',
        title: 'Restricted App Window',
        url: '',
        document: '',
      );

      final result = checker.checkClip(
        ExclusionCheckParams(clip: clip, activity: activity),
      );

      expect(result.isAllowed, isFalse);
      expect(result.reason, ExclusionReason.excludedApp);
      expect(result.matchedDetail, 'CustomRestrictedApp');
    });
  });

  group('ClipboardFeedback Models', () {
    test('initializes ClipboardFeedbackParams with defaults and custom values', () {
      const defaultParams = ClipboardFeedbackParams(showToast: true);
      expect(defaultParams.message, 'Copied');
      expect(defaultParams.icon, ClipboardFeedbackIcon.checkmark);
      expect(defaultParams.showToast, isTrue);

      const exclusionParams = ClipboardFeedbackParams(
        showToast: true,
        message: 'Excluded • Phone',
        icon: ClipboardFeedbackIcon.nosign,
      );
      expect(exclusionParams.message, 'Excluded • Phone');
      expect(exclusionParams.icon, ClipboardFeedbackIcon.nosign);
      expect(exclusionParams.showToast, isTrue);
    });
  });
}
