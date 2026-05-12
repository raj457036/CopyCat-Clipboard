import 'package:flutter/widgets.dart';

/// A scroll behavior that applies a consistent scroll
/// physics across all platforms, preventing the default
/// bouncing behavior on iOS and macOS.
class ClampingScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics();
  }
}
