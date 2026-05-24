import 'package:bloc/bloc.dart';
import 'package:clipboard/base/constants/review_config.dart';
import 'package:clipboard/base/domain/services/in_app_review_service.dart';
import 'package:clipboard/base/domain/services/review_prompt_service.dart';
import 'package:clipboard/common/logging.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:tiny_storage/tiny_storage.dart';

@lazySingleton
class ReviewPromptCubit extends Cubit<int> {
  static const _countKey = 'review.qualifying_event_count';
  static const _lastPromptDateKey = 'review.last_prompt_date';
  static const _neverAskKey = 'review.never_ask';

  final TinyStorage _cache;
  final InAppReviewService _reviewService;

  bool _enabled = false;
  bool _reviewPromptShownThisSession = false;

  ReviewPromptCubit(this._cache, this._reviewService) : super(0);

  void setEnabled(bool enabled) {
    _enabled = enabled;
    if (!enabled) {
      _reviewPromptShownThisSession = false;
    }
  }

  Future<void> trackAppEntry() async {
    final shouldPrompt = await _trackQualifyingEvent();
    if (!shouldPrompt) return;
    emit(state + 1);
  }

  Future<void> trackCopyPasteSuccess() async {
    final shouldPrompt = await _trackQualifyingEvent();
    if (!shouldPrompt) return;
    emit(state + 1);
  }

  Future<bool> _trackQualifyingEvent() async {
    if (!_enabled) return false;

    final count = _getCount() + 1;
    _cache.set(_countKey, count);

    if (!_shouldShowReviewPrompt()) return false;

    _reviewPromptShownThisSession = true;
    return true;
  }

  bool _shouldShowReviewPrompt() {
    if (_reviewPromptShownThisSession) return false;
    if (_cache.get<bool?>(_neverAskKey) == true) return false;

    final lastPrompt = _getLastPromptDate();
    if (lastPrompt != null) {
      final daysSince = DateTime.now().difference(lastPrompt).inDays;
      if (daysSince < ReviewConfig.daysBetweenPrompts) return false;
    }

    return _getCount() >= ReviewConfig.triggerThreshold;
  }

  int _getCount() {
    final value = _cache.get<int?>(_countKey);
    if (value == null || value < 0) return 0;
    return value;
  }

  DateTime? _getLastPromptDate() {
    final raw = _cache.get<String?>(_lastPromptDateKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

  Future<bool> requestReview() async {
    try {
      final available = await _reviewService.isAvailable();
      if (available) {
        await _reviewService.requestReview();
      } else {
        await _reviewService.openStoreListing();
      }
      return true;
    } on PlatformException catch (e) {
      logger.w(
        'InAppReview native sheet unavailable (${e.code}), opening store listing',
      );
      try {
        await _reviewService.openStoreListing();
        return true;
      } catch (e2) {
        logger.e('InAppReview fallback error: $e2');
      }
    } catch (e) {
      logger.e('InAppReview error: $e');
    }
    return false;
  }

  Future<void> recordReviewResponse(ReviewResponse response) {
    switch (response) {
      case ReviewResponse.rateNow:
        _cache.set(_neverAskKey, true);
        _cache.set(_lastPromptDateKey, DateTime.now().toIso8601String());
        _cache.set(_countKey, 0);
      case ReviewResponse.remindLater:
        _cache.set(_lastPromptDateKey, DateTime.now().toIso8601String());
        _cache.set(_countKey, 0);
      case ReviewResponse.never:
        _cache.set(_neverAskKey, true);
        _cache.set(_lastPromptDateKey, DateTime.now().toIso8601String());
    }
    return Future.value();
  }
}
