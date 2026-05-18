import 'dart:io';

class AdMobIds {
  const AdMobIds._();

  // Android still uses Google's sample App ID for development.
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  // iOS uses the configured production App ID.
  static const String iosAppId = 'ca-app-pub-7195864152055881~1402843474';

  // Android still uses Google's sample banner ad unit for development.
  static const String androidBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  // iOS uses the configured production banner ad unit.
  static const String iosBannerAdUnitId =
      'ca-app-pub-7195864152055881/9309253650';

  static bool get supportsMobileAds => Platform.isAndroid || Platform.isIOS;

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return androidBannerAdUnitId;
    }
    if (Platform.isIOS) {
      return iosBannerAdUnitId;
    }

    throw UnsupportedError(
      'Banner ads are only configured for iOS and Android.',
    );
  }
}
