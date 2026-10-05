class ClipHashRegistry {
  ClipHashRegistry._();
  static final instance = ClipHashRegistry._();

  String? _lastHash;
  bool _suppressFeedback = false;

  bool isDuplicate(String? hash) =>
      hash != null && _lastHash != null && hash == _lastHash;

  void register(String? hash, {bool suppressFeedback = false}) {
    if (hash != null) {
      _lastHash = hash;
      _suppressFeedback = suppressFeedback;
    }
  }

  bool consumeFeedbackSuppression([String? hash]) {
    if (_suppressFeedback && (hash == null || hash == _lastHash)) {
      _suppressFeedback = false;
      return true;
    }
    return false;
  }

  void clear() {
    _lastHash = null;
    _suppressFeedback = false;
  }
}
