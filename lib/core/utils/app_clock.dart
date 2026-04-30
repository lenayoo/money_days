class AppClock {
  static DateTime? testNow;

  static DateTime now() {
    return testNow ?? DateTime.now();
  }
}
