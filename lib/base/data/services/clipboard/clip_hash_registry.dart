class ClipHashRegistry {
  ClipHashRegistry._();
  static final instance = ClipHashRegistry._();

  String? _lastHash;

  bool isDuplicate(String? hash) =>
      hash != null && _lastHash != null && hash == _lastHash;

  void register(String? hash) {
    if (hash != null) _lastHash = hash;
  }

  void clear() => _lastHash = null;
}
