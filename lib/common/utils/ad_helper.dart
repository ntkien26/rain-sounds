import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/2934735716"
          : "ca-app-pub-8874925934744732/9301483138";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/4411468910"
          : "ca-app-pub-8874925934744732/1338113072";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return kDebugMode
          ? "ca-app-pub-3940256099942544/1712485313"
          : "ca-app-pub-8874925934744732/4679711848";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3986624511";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;

  int countToDisplayAds = 0;

  final AppCache appCache = getIt.get();

  void showInterstitialAd(
      {required VoidCallback onAdDismissedFullScreenContent}) {
    if (appCache.isPremiumMember()) {
      onAdDismissedFullScreenContent();
      return;
    }

    if (!shouldShowInterstitialAds()) {
      countAds();
      onAdDismissedFullScreenContent();
      return;
    }

    _showInterstitialAd(onAdDismissedFullScreenContent);
  }

  void preloadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Ad loaded');
          _isInterstitialAdReady = true;
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _showInterstitialAd(VoidCallback onAdDismissedFullScreenContent) {
    if (_isInterstitialAdReady && shouldShowInterstitialAds()) {
      _interstitialAd?.show();
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          _isInterstitialAdReady = false;
        },
        onAdDismissedFullScreenContent: (ad) {
          onAdDismissedFullScreenContent();
          ad.dispose();
        },
      );
      print('Ad showed');
      countAds();
      preloadInterstitialAd();
    } else {
      InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            print('Ad loaded');
            _isInterstitialAdReady = true;

            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (ad) {
                _isInterstitialAdReady = false;
              },
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
            );

            _interstitialAd?.show();
          },
          onAdFailedToLoad: (err) {
            print('Failed to load an interstitial ad: ${err.message}');
            _isInterstitialAdReady = false;
          },
        ),
      );
    }
  }

  void countAds() {
    if (countToDisplayAds < 5) {
      countToDisplayAds += 1;
    } else {
      countToDisplayAds = 0;
    }
  }

  void showRewardedAd(
      {required VoidCallback onUserRewarded,
      required Function(bool) isLoadingAd}) {
    isLoadingAd(true);
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          isLoadingAd(false);
          _isRewardedAdReady = true;
          _rewardedAd = ad;
          _showRewardedAd(onUserRewarded);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Reward ads dismissed');
              _isRewardedAdReady = false;
              _rewardedAd.dispose();
            },
          );
        },
        onAdFailedToLoad: (err) {
          isLoadingAd(false);
          print('Failed to load a rewarded ad: ${err.message}');
          _isRewardedAdReady = false;
        },
      ),
    );
  }

  void _showRewardedAd(VoidCallback onUserEarnedReward) {
    if (_isRewardedAdReady) {
      _rewardedAd.show(
          onUserEarnedReward: (AdWithoutView adWithoutView, RewardItem item) {
        print('You got reward: ${item.amount} - ${item.type}');
        onUserEarnedReward();
      });
    } else {
      print('Reward ads not ready');
    }
  }

  bool shouldShowInterstitialAds() {
    print('shouldShowInterstitialAds');
    return countToDisplayAds == 0 || countToDisplayAds == 5;
  }

  bool isInterstitialAdsReady() {
    return _isInterstitialAdReady;
  }
}
