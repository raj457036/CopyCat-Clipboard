import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_result.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/sensitive_info.dart';
import 'package:clipboard/base/domain/services/analysis/text_analysis.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:focus_window/platform/activity_info.dart';
import 'package:universal_io/io.dart';

// patterns
final _creditCardPattern = RegExp(r'\b\d{4} \d{4} \d{4} \d{4}\b');
// Regex to match a combination of letters, digits, and special characters
final passwordPattern = RegExp(
  r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$',
);
// Exclude patterns that are likely not passwords (e.g., hex colors, common words)
final commonWordPattern = RegExp(r'^[a-zA-Z]+$'); // Only alphabets, like a word
final hexPattern = RegExp(r'^#?[A-Fa-f0-9]{6}$'); // Hex color pattern
final otpPattern = RegExp(r'^\d{4,6}$'); // OTP pattern

// Bank account number pattern (6-18 digits or IBAN format 15-34 alphanumeric)
final bankAccountPattern = RegExp(r'^\d{6,18}$|^[A-Z]{2}\d{2}[A-Z0-9]{11,30}$');

// Generic passport number pattern (6-9 alphanumeric characters)
final passportPattern = RegExp(r'^[A-Z0-9]{6,9}$');

class ExclusionChecker {
  final List<RegExp> _rTitle = [];
  final List<RegExp> _rUrls = [];
  // final List<String> _titles;
  // final List<String> _urls;
  final List<RegExp> _patterns;
  final List<AppInfo> _apps;
  final bool _creditCard;
  final bool _phone;
  final bool _passwordManager;
  final bool _email;
  final bool _sensitiveUrls;

  ExclusionChecker(ExclusionRules rules)
    : // _titles = [...rules.titles],
      //       _urls = [...rules.urls],
      _patterns = rules.patterns.map((e) => RegExp(e)).toList(),
      _apps = [...rules.apps],
      _creditCard = rules.creditCard,
      _phone = rules.phone,
      _passwordManager = rules.passwordManager,
      _email = rules.email,
      _sensitiveUrls = rules.sensitiveUrls {
    if (_sensitiveUrls) {
      if (Platform.isMacOS) {
        _rUrls.add(
          RegExp(
            sensitiveUrlKeywords.join("|"),
            caseSensitive: false,
            multiLine: true,
          ),
        );
      }

      _rTitle.add(
        RegExp(
          sensitiveTitlesKeywords.join("|"),
          caseSensitive: false,
          multiLine: true,
        ),
      );
    }

    if (rules.titles.isNotEmpty) {
      _rTitle.add(
        RegExp(rules.titles.join("|"), caseSensitive: false, multiLine: true),
      );
    }

    if (rules.urls.isNotEmpty && Platform.isMacOS) {
      _rUrls.add(
        RegExp(rules.urls.join("|"), caseSensitive: false, multiLine: true),
      );
    }

    if (_passwordManager) {
      _apps.addAll(sensitiveExcludedApps);
    }
  }

  bool isPatternExcluded(String text) {
    return _patterns.any((pattern) => pattern.hasMatch(text));
  }

  ExclusionCheckResult checkActivity(ActivityInfo activity) {
    for (final app in _apps) {
      if (app.identifier != null &&
          (activity.identifier.isNotEmpty &&
              activity.identifier == app.identifier!) &&
          (activity.app.isNotEmpty && app.name == activity.app)) {
        logger.w("Excluded pattern detected for the app.");
        return ExclusionCheckResult.excluded(
          reason: ExclusionReason.excludedApp,
          matchedDetail: app.name.isNotEmpty ? app.name : activity.app,
        );
      }
      if (activity.appFileName.startsWith(app.name)) {
        logger.w("Excluded pattern detected for the app name.");
        return ExclusionCheckResult.excluded(
          reason: ExclusionReason.excludedApp,
          matchedDetail: app.name,
        );
      }
      if (app.path != null && activity.appFilePath.endsWith(app.path!)) {
        logger.w("Excluded pattern detected for the app path.");
        return ExclusionCheckResult.excluded(
          reason: ExclusionReason.excludedApp,
          matchedDetail: app.name,
        );
      }
    }

    if (activity.title.isNotEmpty) {
      final hasMatch = _rTitle.any((r) => r.hasMatch(activity.title));
      if (hasMatch) {
        logger.w("Excluded pattern detected in title");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.windowTitle,
        );
      }
    }
    if (activity.url.isNotEmpty && Platform.isMacOS) {
      final hasMatch = _rUrls.any((r) => activity.url.contains(r));
      if (hasMatch) {
        logger.w("Excluded pattern detected in url");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.sensitiveUrl,
        );
      }
    }

    return const ExclusionCheckResult.allowed();
  }

  bool isActivityAllowed(ActivityInfo activity) {
    return checkActivity(activity).isAllowed;
  }

  ExclusionCheckResult checkClip(ExclusionCheckParams params) {
    final clip = params.clip;
    final activity = params.activity;

    if (activity != null) {
      final activityResult = checkActivity(activity);
      if (!activityResult.isAllowed) {
        return activityResult;
      }
    }

    if (clip.isText && clip.text != null) {
      final text = clip.text!;
      if (_creditCard && _creditCardPattern.hasMatch(text)) {
        logger.w("Exclusion rule triggered for credit card");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.creditCard,
        );
      }
      if (_email &&
          (clip.textCategory == TextCategory.email ||
              TextAnalysis.containsEmail(text))) {
        logger.w("Exclusion rule triggered for email");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.email,
        );
      }
      if (_phone &&
          (clip.textCategory == TextCategory.phone ||
              TextAnalysis.containsPhone(text))) {
        logger.w("Exclusion rule triggered for phone number");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.phone,
        );
      }
      if (isPatternExcluded(text)) {
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.pattern,
        );
      }
    }

    if (_sensitiveUrls && clip.isUri && clip.uri != null) {
      final uriStr = clip.uri!.toString();
      if (_rUrls.any((r) => r.hasMatch(uriStr))) {
        logger.w("Exclusion rule triggered for sensitive url");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.sensitiveUrl,
        );
      }
    }

    if (_patterns.isNotEmpty && clip.text != null) {
      final found = _patterns.any((pattern) => pattern.hasMatch(clip.text!));
      if (found) {
        logger.w("Exclusion rule triggered for custom pattern.");
        return const ExclusionCheckResult.excluded(
          reason: ExclusionReason.pattern,
        );
      }
    }

    return const ExclusionCheckResult.allowed();
  }

  bool isClipAllowed(ClipItem clip, ActivityInfo? activity) {
    return checkClip(
      ExclusionCheckParams(clip: clip, activity: activity),
    ).isAllowed;
  }
}
