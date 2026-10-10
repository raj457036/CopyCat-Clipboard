part of 'offline_persistance_cubit.dart';

mixin OfflinePersistenceFeedbackMixin on Cubit<OfflinePersistanceState> {
  AppConfigCubit get appConfig;
  UserDevicesCubit get userDevicesCubit;

  String _resolveDeviceName(ClipboardItem item) {
    if (item.deviceId != null && item.deviceId!.isNotEmpty) {
      final String? name = userDevicesCubit.getDeviceName(item.deviceId!);
      if (name != null && name.isNotEmpty) return name;
    }
    return item.os.displayName;
  }

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
    final String label = formatExclusionLabel(result);
    await showCopyFeedback(label, ClipboardFeedbackIcon.nosign);
  }

  bool _isCopyFeedbackEnabled() {
    final ClipboardFeedbackMode mode =
        appConfig.state.config.clipboardFeedbackMode;
    return mode == ClipboardFeedbackMode.copyOnly ||
        mode == ClipboardFeedbackMode.copyAndSync ||
        mode == ClipboardFeedbackMode.toast;
  }

  bool _isSyncFeedbackEnabled() {
    final ClipboardFeedbackMode mode =
        appConfig.state.config.clipboardFeedbackMode;
    return mode == ClipboardFeedbackMode.syncOnly ||
        mode == ClipboardFeedbackMode.copyAndSync ||
        mode == ClipboardFeedbackMode.toast;
  }

  Future<void> showCopyFeedback([
    String? message,
    ClipboardFeedbackIcon icon = ClipboardFeedbackIcon.checkmark,
  ]) async {
    if (!(Platform.isMacOS || Platform.isWindows)) return;
    if (!_isCopyFeedbackEnabled()) return;

    final String copiedLabel =
        message ??
        rootNavigationKey.currentContext?.locale.app__ack__copied ??
        'Copied';

    unawaited(
      ClipboardFeedbackService.i.notifyFeedback(
        ClipboardFeedbackParams(
          showToast: true,
          message: copiedLabel,
          icon: icon,
        ),
      ),
    );
  }

  Future<void> showSyncFeedback(ClipboardItem item) async {
    if (!(Platform.isMacOS || Platform.isWindows)) return;
    if (!_isSyncFeedbackEnabled()) return;

    final String deviceName = _resolveDeviceName(item);
    final String message = appConfig.state.config.autoWriteOnReceive
        ? (rootNavigationKey.currentContext?.locale.app__ack__copied_from_device(
              device: deviceName,
            ) ??
            'Copied from $deviceName')
        : (rootNavigationKey.currentContext?.locale.app__ack__received_from_device(
              device: deviceName,
            ) ??
            'Received from $deviceName');

    unawaited(
      ClipboardFeedbackService.i.notifyFeedback(
        ClipboardFeedbackParams(
          showToast: true,
          message: message,
          icon: ClipboardFeedbackIcon.checkmark,
        ),
      ),
    );
  }

  Future<void> showFeedback([
    String? message,
    ClipboardFeedbackIcon icon = ClipboardFeedbackIcon.checkmark,
  ]) async => showCopyFeedback(message, icon);
}
