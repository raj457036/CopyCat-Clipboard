import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_result.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/domain/model/exclusion_rules/sensitive_info.dart';
import 'package:clipboard/base/domain/services/analysis/text_analysis.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:focus_window/platform/activity_info.dart';

// patterns
final _creditCardPattern = RegExp(r'\b\d{4} \d{4} \d{4} \d{4}\b');

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

  static List<RegExp> _buildBoundaryPatterns(Iterable<String> items) {
    if (items.isEmpty) return const [];
    final patterns = <String>[];
    for (final raw in items) {
      final item = raw.trim();
      if (item.isEmpty) continue;
      final escaped = RegExp.escape(item);
      final prefix = RegExp(r'^\w').hasMatch(item) ? r'\b' : '';
      final suffix = RegExp(r'\w$').hasMatch(item) ? r'\b' : '';
      patterns.add('$prefix$escaped$suffix');
    }
    if (patterns.isEmpty) return const [];
    return [RegExp(patterns.join('|'), caseSensitive: false, multiLine: true)];
  }

  ExclusionChecker(ExclusionRules rules)
    : _patterns = rules.patterns.map((e) => RegExp(e)).toList(),
      _apps = [...rules.apps],
      _creditCard = rules.creditCard,
      _phone = rules.phone,
      _passwordManager = rules.passwordManager,
      _email = rules.email,
      _sensitiveUrls = rules.sensitiveUrls {
    if (_sensitiveUrls) {
      _rUrls.addAll(_buildBoundaryPatterns(sensitiveUrlKeywords));
      _rTitle.addAll(_buildBoundaryPatterns(sensitiveTitlesKeywords));
    }

    if (rules.titles.isNotEmpty) {
      _rTitle.addAll(_buildBoundaryPatterns(rules.titles));
    }

    if (rules.urls.isNotEmpty) {
      _rUrls.addAll(_buildBoundaryPatterns(rules.urls));
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
    if (activity.url.isNotEmpty) {
      final hasMatch = _rUrls.any((r) => r.hasMatch(activity.url));
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

    if (clip.isUri && clip.uri != null) {
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
