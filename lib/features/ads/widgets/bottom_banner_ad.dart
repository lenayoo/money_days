import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/theme/app_colors.dart';
import '../../settings/controllers/settings_controller.dart';
import '../models/admob_ids.dart';

class BottomBannerAd extends ConsumerWidget {
  const BottomBannerAd({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremium = ref.watch(
      settingsControllerProvider.select((settings) => settings.isPremium),
    );

    if (isPremium || !AdMobIds.supportsMobileAds) {
      return const SizedBox.shrink();
    }

    return const _BottomBannerAdSlot();
  }
}

class _BottomBannerAdSlot extends StatefulWidget {
  const _BottomBannerAdSlot();

  @override
  State<_BottomBannerAdSlot> createState() => _BottomBannerAdSlotState();
}

class _BottomBannerAdSlotState extends State<_BottomBannerAdSlot> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    final bannerAd = BannerAd(
      adUnitId: AdMobIds.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }

          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Bottom banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final bannerAd = _bannerAd;
    if (!_isLoaded || bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 12),
        child: Center(
          child: Container(
            width: bannerAd.size.width.toDouble(),
            height: bannerAd.size.height.toDouble(),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.border),
            ),
            clipBehavior: Clip.antiAlias,
            child: AdWidget(ad: bannerAd),
          ),
        ),
      ),
    );
  }
}
