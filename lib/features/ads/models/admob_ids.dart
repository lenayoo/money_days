import 'dart:io';

class AdMobIds {
  const AdMobIds._();

  // Google sample App IDs for SDK setup during development only.
  static const String androidAppId = 'ca-app-pub-3940256099942544~3347511713';
  static const String iosAppId = 'ca-app-pub-3940256099942544~1458002511';

  // Google sample Banner Ad Unit IDs for development only.
  static const String androidBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerAdUnitId =
      'ca-app-pub-3940256099942544/2934735716';

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
