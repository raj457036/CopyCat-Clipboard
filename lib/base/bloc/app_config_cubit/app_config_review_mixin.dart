part of 'app_config_cubit.dart';

enum ReviewResponse { rateNow, remindLater, never }

mixin AppConfigReviewMixin on Cubit<AppConfigState> {
  /// Prevents showing the review prompt dialog more than once per app session.
  bool _reviewPromptShownThisSession = false;

  AppConfigRepository get repo;
  InAppReviewService get reviewService;

  void _queueReviewPromptIfEligible() {
    if (!shouldShowReviewPrompt()) return;
    markReviewPromptShown();
    emit(state.copyWith(reviewPromptSignal: state.reviewPromptSignal + 1));
  }

  /// Increments the copy/paste success counter (all platforms).
  Future<void> trackCopyPasteSuccess() async {
    final newConfig = state.config.copyWith(
      reviewQualifyingEventCount: state.config.reviewQualifyingEventCount + 1,
    );
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
    _queueReviewPromptIfEligible();
  }

  /// Increments the app open/focus counter.
  ///
  /// Mobile: explicit app launches.
  /// Desktop: window focus/foreground events.
  Future<void> trackAppEntry() async {
    final newConfig = state.config.copyWith(
      reviewQualifyingEventCount: state.config.reviewQualifyingEventCount + 1,
    );
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
    _queueReviewPromptIfEligible();
  }

  /// Eligibility check for showing the review prompt dialog.
  bool shouldShowReviewPrompt() {
    if (_reviewPromptShownThisSession) return false;
    if (state.config.reviewNeverAsk) return false;

    final lastPrompt = state.config.lastReviewPromptDate;
    if (lastPrompt != null) {
      final daysSince = DateTime.now().difference(lastPrompt).inDays;
      if (daysSince < ReviewConfig.daysBetweenPrompts) return false;
    }

    const threshold = ReviewConfig.triggerThreshold;
    return state.config.reviewQualifyingEventCount >= threshold;
  }

  /// Called when the review dialog is about to be presented.
  /// Prevents re-showing within the same session.
  void markReviewPromptShown() => _reviewPromptShownThisSession = true;

  /// Records the user's response and persists the relevant state.
  Future<void> recordReviewResponse(ReviewResponse response) async {
    final AppConfig newConfig;
    switch (response) {
      case ReviewResponse.rateNow:
        // User is rating, never prompt again.
        newConfig = state.config.copyWith(
          reviewNeverAsk: true,
          lastReviewPromptDate: DateTime.now(),
          reviewQualifyingEventCount: 0,
        );
      case ReviewResponse.remindLater:
        // Reset counters and record date so we wait the full window again.
        newConfig = state.config.copyWith(
          lastReviewPromptDate: DateTime.now(),
          reviewQualifyingEventCount: 0,
        );
      case ReviewResponse.never:
        newConfig = state.config.copyWith(
          reviewNeverAsk: true,
          lastReviewPromptDate: DateTime.now(),
        );
    }
    emit(state.copyWith(config: newConfig));
    await repo.update(newConfig);
  }

  /// Triggers the native review flow
  Future<void> requestReview() async {
    try {
      final available = await reviewService.isAvailable();
      if (available) {
        await reviewService.requestReview();
      } else {
        await reviewService.openStoreListing();
      }
    } catch (e) {
      logger.e('InAppReview error: $e');
    }
  }
}
