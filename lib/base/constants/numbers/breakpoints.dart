class Breakpoints {
  const Breakpoints._();

  static const xs = 0.0;
  static const sm = 640.0;
  static const md = 768.0;
  static const lg = 1024.0;
  static const xl = 1280.0;
  static const xxl = 1536.0;
  static const ultra = 1920.0;

  static bool isMobile(double w) => w < md;
  static bool isTablet(double w) => w >= md && w < lg;
  static bool isDesktop(double w) => w >= lg && w < xl;
  static bool isLargeDesktop(double w) => w >= xl && w < xxl;
  static bool isUltraWide(double w) => w >= xxl;

  static T on<T>(
    double width, {
    T? mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
    T? ultraWide,
    required T fallback,
  }) {
    if (isMobile(width)) return mobile ?? fallback;
    if (isTablet(width)) return tablet ?? fallback;
    if (isDesktop(width)) return desktop ?? fallback;
    if (isLargeDesktop(width)) return largeDesktop ?? fallback;
    if (isUltraWide(width)) return ultraWide ?? fallback;

    return fallback;
  }
}
