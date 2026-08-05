import 'dart:async';

import 'package:synchronized/synchronized.dart';

/// A global state resolving mechanism that allows for waiting on a state to be set.
class GlobalState {
  bool _state = false;
  bool _intermediate = true;

  final Lock _lock = Lock();

  final List<Completer<bool>> _subscribers = [];

  GlobalState(bool state) : _state = state;

  Future<bool> call() async {
    if (!_intermediate) return _state;

    final completer = Completer<bool>();

    await _lock.synchronized(() async {
      _subscribers.add(completer);
    });

    return completer.future;
  }

  bool get isWaiting => _intermediate;

  /// Waits for the state to be set.
  void wait() => _intermediate = true;

  Future<void> set(bool val) async {
    await _lock.synchronized(() async {
      _state = val;

      for (final sub in _subscribers) {
        sub.complete(val);
      }
      _subscribers.clear();
      _intermediate = false;
    });
  }
}

/// A global flag to indicate whether the internet is connected.
final internetConnected = GlobalState(false);

/// A global flag to indicate whether the window size has stabilized after the initial setup.
final windowSizeStabilized = GlobalState(false);
