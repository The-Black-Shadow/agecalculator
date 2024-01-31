import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7040228706164271/2255687112';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (Ad ad) => debugPrint('Ad loaded.'),
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      ad.dispose();
      debugPrint('Ad failed to load: $error');
    },
    onAdOpened: (Ad ad) => debugPrint('Ad opened.'),
    onAdClosed: (Ad ad) => debugPrint('Ad closed.'),
    onAdImpression: (Ad ad) => debugPrint('Ad impression.'),
  );
}
