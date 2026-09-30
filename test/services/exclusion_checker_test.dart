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

    test('excludes sensitive URLs and token parameters', () {
      final tokenClip = ClipItem.uri(
        uri: Uri.parse('https://example.com/auth/callback?token=secret_abc123'),
      );
      final paymentClip = ClipItem.uri(
        uri: Uri.parse('https://store.example.com/checkout/payment'),
      );
      final oauthClip = ClipItem.uri(
        uri: Uri.parse('https://accounts.google.com/o/oauth2/v2/auth'),
      );
      final accessTokenClip = ClipItem.uri(
        uri: Uri.parse('https://api.example.com/v1/user?access_token=xyz987'),
      );

      expect(checker.checkClip(ExclusionCheckParams(clip: tokenClip)).isAllowed, isFalse);
      expect(checker.checkClip(ExclusionCheckParams(clip: tokenClip)).reason, ExclusionReason.sensitiveUrl);

      expect(checker.checkClip(ExclusionCheckParams(clip: paymentClip)).isAllowed, isFalse);
      expect(checker.checkClip(ExclusionCheckParams(clip: paymentClip)).reason, ExclusionReason.sensitiveUrl);

      expect(checker.checkClip(ExclusionCheckParams(clip: oauthClip)).isAllowed, isFalse);
      expect(checker.checkClip(ExclusionCheckParams(clip: oauthClip)).reason, ExclusionReason.sensitiveUrl);

      expect(checker.checkClip(ExclusionCheckParams(clip: accessTokenClip)).isAllowed, isFalse);
      expect(checker.checkClip(ExclusionCheckParams(clip: accessTokenClip)).reason, ExclusionReason.sensitiveUrl);
    });

    test('does not falsely exclude benign URLs with substring collisions (display, border, join, pinterest)', () {
      final borderClip = ClipItem.uri(
        uri: Uri.parse('https://developer.mozilla.org/en-US/docs/Web/CSS/border'),
      );
      final displayClip = ClipItem.uri(
        uri: Uri.parse('https://css-tricks.com/almanac/properties/d/display/'),
      );
      final joinClip = ClipItem.uri(
        uri: Uri.parse('https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/join'),
      );
      final pinterestClip = ClipItem.uri(
        uri: Uri.parse('https://www.pinterest.com/pin/123456789/'),
      );

      expect(checker.checkClip(ExclusionCheckParams(clip: borderClip)).isAllowed, isTrue);
      expect(checker.checkClip(ExclusionCheckParams(clip: displayClip)).isAllowed, isTrue);
      expect(checker.checkClip(ExclusionCheckParams(clip: joinClip)).isAllowed, isTrue);
      expect(checker.checkClip(ExclusionCheckParams(clip: pinterestClip)).isAllowed, isTrue);
    });

    test('does not falsely exclude benign window titles (apply, submit, order)', () {
      const applyActivity = ActivityInfo(
        pid: 2001,
        app: 'Browser',
        identifier: 'com.google.Chrome',
        appFileName: 'Google Chrome',
        appFilePath: '/Applications/Google Chrome.app',
        title: 'Function.prototype.apply() - JavaScript | MDN',
        url: '',
        document: '',
      );
      const submitActivity = ActivityInfo(
        pid: 2002,
        app: 'Browser',
        identifier: 'com.google.Chrome',
        appFileName: 'Google Chrome',
        appFilePath: '/Applications/Google Chrome.app',
        title: 'Submit a pull request · raj457036/CopyCat',
        url: '',
        document: '',
      );

      final clip = ClipItem.text(text: 'const x = 1;');
      expect(checker.checkClip(ExclusionCheckParams(clip: clip, activity: applyActivity)).isAllowed, isTrue);
      expect(checker.checkClip(ExclusionCheckParams(clip: clip, activity: submitActivity)).isAllowed, isTrue);
    });

    test('excludes sensitive window titles matching boundary phrases', () {
      const accountSettingsActivity = ActivityInfo(
        pid: 2003,
        app: 'Browser',
        identifier: 'com.google.Chrome',
        appFileName: 'Google Chrome',
        appFilePath: '/Applications/Google Chrome.app',
        title: 'Google Account Settings',
        url: '',
        document: '',
      );
      const pinActivity = ActivityInfo(
        pid: 2004,
        app: 'SecurityApp',
        identifier: 'com.example.security',
        appFileName: 'SecurityApp',
        appFilePath: '/Applications/SecurityApp.app',
        title: 'Please Enter PIN Code to Proceed',
        url: '',
        document: '',
      );

      final clip = ClipItem.text(text: 'secret content');
      final result1 = checker.checkClip(ExclusionCheckParams(clip: clip, activity: accountSettingsActivity));
      final result2 = checker.checkClip(ExclusionCheckParams(clip: clip, activity: pinActivity));

      expect(result1.isAllowed, isFalse);
      expect(result1.reason, ExclusionReason.windowTitle);

      expect(result2.isAllowed, isFalse);
      expect(result2.reason, ExclusionReason.windowTitle);
    });

    test('safely escapes user-provided custom URLs and titles containing regex characters', () {
      final customChecker = ExclusionChecker(
        ExclusionRules(
          sensitiveUrls: false,
          urls: ['test.com/path?key=value', 'special[name].org'],
          titles: ['Title with (Parentheses) & Dots...'],
        ),
      );

      final matchingClip = ClipItem.uri(
        uri: Uri.parse('https://test.com/path?key=value'),
      );
      final nonMatchingClip = ClipItem.uri(
        uri: Uri.parse('https://test.com/pathXkey=value'),
      );

      expect(customChecker.checkClip(ExclusionCheckParams(clip: matchingClip)).isAllowed, isFalse);
      expect(customChecker.checkClip(ExclusionCheckParams(clip: nonMatchingClip)).isAllowed, isTrue);

      const matchingActivity = ActivityInfo(
        pid: 3001,
        app: 'Test',
        identifier: 'com.test',
        appFileName: 'Test',
        appFilePath: '/Test',
        title: 'Title with (Parentheses) & Dots...',
        url: '',
        document: '',
      );
      expect(customChecker.checkActivity(matchingActivity).isAllowed, isFalse);
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
