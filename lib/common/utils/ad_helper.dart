import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  late RewardedAd _rewardedAd;
  bool _isRewardedAdReady = false;

  int countToDisplayAds = 0;

  void showInterstitialAd(
      {required VoidCallback onAdShowedFullScreenContent,
      required VoidCallback onAdDismissedFullScreenContent}) {
    if (!shouldShowInterstitialAds()) {
      onAdDismissedFullScreenContent();
      countAds();
      return;
    }

    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('Ad loaded');
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (ad) {
              onAdShowedFullScreenContent();
              _isInterstitialAdReady = false;
              _interstitialAd = null;
            },
            onAdDismissedFullScreenContent: (ad) {
              onAdDismissedFullScreenContent();
              ad.dispose();
            },
          );
          _isInterstitialAdReady = true;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isInterstitialAdReady && shouldShowInterstitialAds()) {
      _interstitialAd?.show();
      print('Ad showed');
      countAds();
    }
  }

  void countAds() {
    if (countToDisplayAds < 5) {
      countToDisplayAds += 1;
    } else {
      countToDisplayAds = 0;
    }
  }

  void showRewardedAd({required VoidCallback onUserRewarded}) {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _showRewardedAd(onUserRewarded);
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Reward ads dismissed');
              _isRewardedAdReady = false;
              _rewardedAd.dispose();
            },
          );
          _isRewardedAdReady = true;
        },
        onAdFailedToLoad: (err) {
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
    }
  }

  bool shouldShowInterstitialAds() {
    print('shouldShowInterstitialAds');
    return countToDisplayAds == 0 || countToDisplayAds == 5;
  }
}
