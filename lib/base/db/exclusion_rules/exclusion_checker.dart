import 'package:clipboard/base/data/services/clipboard_service.dart';
import 'package:clipboard/base/db/exclusion_rules/exclusion_rules.dart';
import 'package:clipboard/base/db/exclusion_rules/sensitive_info.dart';
import 'package:clipboard/base/enums/clip_type.dart';
import 'package:clipboard/common/logging.dart';
import 'package:focus_window/platform/activity_info.dart';
import 'package:universal_io/io.dart';

// patterns
final _creditCardPattern = RegExp(r'\b\d{4} \d{4} \d{4} \d{4}\b');
// Regex to match a combination of letters, digits, and special characters
final passwordPattern =
    RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*()_+=-]).{8,}$');
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

  ExclusionChecker(
    ExclusionRules rules,
  )   :
        // _titles = [...rules.titles],
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
      _rTitle.add(RegExp(
        rules.titles.join("|"),
        caseSensitive: false,
        multiLine: true,
      ));
    }

    if (rules.urls.isNotEmpty && Platform.isMacOS) {
      _rUrls.add(RegExp(
        rules.urls.join("|"),
        caseSensitive: false,
        multiLine: true,
      ));
    }

    if (_passwordManager) {
      _apps.addAll(sensitiveExcludedApps);
    }
  }

  bool isPatternExcluded(String text) {
    return _patterns.any((pattern) => pattern.hasMatch(text));
  }

  bool isClipAllowed(ClipItem clip, ActivityInfo? activity) {
    if (clip.isText) {
      if (isPatternExcluded(clip.text!)) return false;
      if (_phone && clip.textCategory == TextCategory.phone) {
        logger.w("Exclusion rule triggered for phone numebr");
        return false;
      }
      if (_email && clip.textCategory == TextCategory.email) {
        logger.w("Exclusion rule triggered for email");
        return false;
      }
      if (_creditCard && _creditCardPattern.hasMatch(clip.text!)) {
        logger.w("Exclusion rule triggered for credit card");
        return false;
      }
      // if (_bankAccount && bankAccountPattern.hasMatch(clip.text!)) return false;
      // if (_personalInfo && passportPattern.hasMatch(clip.text!)) return false;
    }
    if (_sensitiveUrls) {
      final p0 = activity != null ? isActivityAllowed(activity) : true;
      if (clip.isUri) {
        final p1 = !_rUrls.any((r) => r.hasMatch(clip.uri!.toString())) && p0;
        if (!p1) {
          logger.w("Exclusion rule triggered for sensitive url");
        }
        return p1;
      }
      return p0;
    }

    if (_patterns.isNotEmpty) {
      final found = _patterns.any((pattern) => pattern.hasMatch(clip.text!));
      if (found) {
        logger.w("Exclusion rule triggered for custom pattern.");
        return false;
      }
    }
    return true;
  }

  bool isActivityAllowed(ActivityInfo activity) {
    if (activity.title.isNotEmpty) {
      final hasMatch = _rTitle.any((r) => r.hasMatch(activity.title));
      if (hasMatch) {
        logger.w("Excluded pattern detected in title");
        return false;
      }
    }
    if (activity.url.isNotEmpty && Platform.isMacOS) {
      final hasMatch = _rUrls.any((r) => activity.url.contains(r));
      if (hasMatch) {
        logger.w("Excluded pattern detected in url");
        return false;
      }
    }

    for (final app in _apps) {
      if (app.identifier != null &&
          (activity.identifier.isNotEmpty &&
              activity.identifier == app.identifier!) &&
          (activity.app.isNotEmpty && app.name == activity.app)) {
        logger.w("Excluded pattern detected for the app.");

        return false;
      }
      if (activity.appFileName.startsWith(app.name)) {
        logger.w("Excluded pattern detected for the app name.");
        return false;
      }
      if (app.path != null && activity.appFilePath.endsWith(app.path!)) {
        logger.w("Excluded pattern detected for the app path.");
        return false;
      }
    }

    return true;
  }
}
