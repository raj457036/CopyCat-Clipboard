import 'package:clipboard/base/data/services/clipboard/clip_models.dart';
import 'package:focus_window/platform/activity_info.dart';

enum ExclusionReason {
  phone,
  email,
  creditCard,
  sensitiveUrl,
  excludedApp,
  windowTitle,
  pattern,
}

class ExclusionCheckParams {
  final ClipItem clip;
  final ActivityInfo? activity;

  const ExclusionCheckParams({
    required this.clip,
    this.activity,
  });
}

class ExclusionCheckResult {
  final bool isAllowed;
  final ExclusionReason? reason;
  final String? matchedDetail;

  const ExclusionCheckResult.allowed()
      : isAllowed = true,
        reason = null,
        matchedDetail = null;

  const ExclusionCheckResult.excluded({
    required this.reason,
    this.matchedDetail,
  }) : isAllowed = false;

  @override
  String toString() {
    return 'ExclusionCheckResult(isAllowed: $isAllowed, reason: $reason, matchedDetail: $matchedDetail)';
  }
}
