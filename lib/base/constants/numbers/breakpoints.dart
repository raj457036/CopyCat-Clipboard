class Breakpoints {
  const Breakpoints._();
  static const double xs = 576;
  static const double sm = 768;
  static const double md = 992;
  static const double lg = 1200;
  static const double xl = 1920;

  static bool isMobile(double value) => value <= xs;
  static bool isTablet(double value) => value > xs && value <= md;
  static bool isDesktop(double value) => value >= md && value < lg;
  static bool isXLDesktop(double value) => value >= lg && value < xl;
  static bool isXXLDesktop(double value) => value >= xl;

  static T on<T>(
    double value, {
    T? mobile,
    T? tablet,
    T? desktop,
    T? xldesktop,
    T? xxldesktop,
    required T default_,
  }) {
    if (isMobile(value)) return mobile ?? default_;
    if (isTablet(value)) return tablet ?? default_;
    if (isDesktop(value)) return desktop ?? default_;
    if (isXLDesktop(value)) return xldesktop ?? default_;
    if (isXXLDesktop(value)) return xxldesktop ?? default_;
    return default_;
  }
}
