/// Thresholds and timing constants for the in-app review prompt.
abstract final class ReviewConfig {
  /// Number of qualifying events (launches / copy-paste / foreground) that
  /// must occur before the review prompt is eligible to appear.
  static const int triggerThreshold = 10;

  /// Minimum number of days that must have elapsed since the last prompt
  /// before the user is asked again (applies to "Remind me in 7 days").
  static const int daysBetweenPrompts = 7;
}
