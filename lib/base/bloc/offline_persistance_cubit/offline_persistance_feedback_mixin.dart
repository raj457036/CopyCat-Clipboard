part of 'offline_persistance_cubit.dart';

mixin OfflinePersistenceFeedbackMixin on Cubit<OfflinePersistanceState> {
  AppConfigCubit get appConfig;

  String formatExclusionLabel(ExclusionCheckResult result) {
    final l10n = rootNavigationKey.currentContext?.locale;
    final fallbackExcluded = l10n?.app__ack__excluded ?? 'Excluded';

    String? reasonText;
    switch (result.reason) {
      case ExclusionReason.phone:
        reasonText = l10n?.app__ack__reason_phone ?? 'Phone';
      case ExclusionReason.email:
        reasonText = l10n?.app__ack__reason_email ?? 'Email';
      case ExclusionReason.creditCard:
        reasonText = l10n?.app__ack__reason_credit_card ?? 'Credit Card';
      case ExclusionReason.sensitiveUrl:
        reasonText = l10n?.app__ack__reason_sensitive_url ?? 'Sensitive URL';
      case ExclusionReason.excludedApp:
        reasonText = result.matchedDetail != null && result.matchedDetail!.isNotEmpty
            ? result.matchedDetail
            : (l10n?.app__ack__reason_app ?? 'Sensitive App');
      case ExclusionReason.pattern:
        reasonText = l10n?.app__ack__reason_pattern ?? 'Pattern';
      case ExclusionReason.windowTitle:
        reasonText = l10n?.app__ack__reason_title ?? 'Sensitive Window';
      case null:
    }

    if (reasonText != null && reasonText.isNotEmpty) {
      return l10n?.app__ack__excluded_with_reason(reason: reasonText) ??
          'Excluded • $reasonText';
    }
    return fallbackExcluded;
  }

  Future<void> showExclusionFeedback(ExclusionCheckResult result) async {
    final label = formatExclusionLabel(result);
    await showFeedback(label, ClipboardFeedbackIcon.nosign);
  }

  Future<void> showFeedback([
    String? message,
    ClipboardFeedbackIcon icon = ClipboardFeedbackIcon.checkmark,
  ]) async {
    if (!(Platform.isMacOS || Platform.isWindows)) return;
    final feedbackMode = appConfig.state.config.clipboardFeedbackMode;
    final copiedLabel =
        message ??
        rootNavigationKey.currentContext?.locale.app__ack__copied ??
        'Copied';
    final showToast = feedbackMode == ClipboardFeedbackMode.toast;
    unawaited(
      ClipboardFeedbackService.i.notifyFeedback(
        ClipboardFeedbackParams(
          showToast: showToast,
          message: copiedLabel,
          icon: icon,
        ),
      ),
    );
  }
}
