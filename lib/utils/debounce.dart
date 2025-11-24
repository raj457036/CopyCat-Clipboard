import 'dart:async';

import 'package:flutter/foundation.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void call(VoidCallback action) {
    // Cancel any existing timer to debounce the call
    if (_timer != null) {
      _timer!.cancel();
    }

    // Set up a new timer
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
