import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';

class InterstitialAdManager {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  int clickCount = -1; // Đặt -1 để hiển thị quảng cáo ngay từ lần nhấp đầu tiên
  bool isNavigating = false; // Biến trạng thái để ngăn chuyển màn hình nhiều lần

  /// Tải quảng cáo Interstitial
  void loadAd(BuildContext context) {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId, // Thay bằng ID quảng cáo của bạn
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          print('Interstitial ad loaded.');
        },
        onAdFailedToLoad: (error) {
          Navigator.of(context).pop(); // Đóng thông báo khi lỗi
          print('Failed to load interstitial ad: ${error.message}');
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Kiểm tra và hiển thị quảng cáo nếu cần
  void checkAndShowAd(BuildContext context, Widget nextScreen) {
    if (isNavigating) return; // Ngăn chuyển màn hình nếu đang xử lý
    isNavigating = true; // Đặt trạng thái là đang chuyển màn hình
    clickCount++; // Tăng số lần nhấp
    if (clickCount == 0 || clickCount % 3 == 0) {
      showAd(context, nextScreen);
    } else {
      // Chuyển màn hình ngay nếu không cần hiển thị quảng cáo
      navigateToNextScreen(context, nextScreen);
    }
  }

  void navigateToNextScreen(BuildContext context, Widget nextScreen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => nextScreen))
        .then((_) {
      isNavigating = false; // Đặt lại trạng thái sau khi quay lại
    });
  }

  /// Hiển thị quảng cáo Interstitial
  void showAd(BuildContext context, Widget nextScreen) {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Interstitial ad dismissed.');
          ad.dispose();
          _isAdLoaded = false;
          loadAd(context); // Tải lại quảng cáo sau khi đóng
          navigateToNextScreen(context, nextScreen); // Chuyển màn hình sau khi đóng quảng cáo
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to show interstitial ad: ${error.message}');
          ad.dispose();
          _isAdLoaded = false;
          loadAd(context); // Tải lại nếu không hiển thị được
          navigateToNextScreen(context, nextScreen); // Chuyển màn hình nếu quảng cáo không hiển thị
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null; // Đặt về null để chuẩn bị tải quảng cáo mới
    } else {
      print('Interstitial ad is not ready yet.');
      loadAd(context); // Tải lại nếu chưa sẵn sàng
      navigateToNextScreen(context, nextScreen); // Chuyển màn hình nếu quảng cáo chưa sẵn sàng
    }
  }

  /// Hủy quảng cáo khi không cần thiết
  void dispose() {
    _interstitialAd?.dispose();
  }
}
