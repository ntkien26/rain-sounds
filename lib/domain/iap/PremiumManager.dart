import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';

import '../../presentation/base/base_stateful_widget.dart';

class PremiumManager {
  static final PremiumManager _instance = PremiumManager._internal();
  final InAppPurchase _iap = InAppPurchase.instance;

  static const List<String> _premiumProducts = [
    'monthly_subscription_premium',
    'yearly_subscription',
    'lifetime_access',
  ];

  List<ProductDetails> availableProducts = [];

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  PremiumManager._internal();

  factory PremiumManager() => _instance;

  // Khởi tạo IAP
  Future<void> initialize() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      debugPrint('IAP is not available');
      return;
    }

    // Lấy danh sách sản phẩm từ Google Play / App Store
    final ProductDetailsResponse response =
    await _iap.queryProductDetails(_premiumProducts.toSet());
    if (response.error != null) {
      debugPrint('Error fetching products: ${response.error}');
      return;
    }

    availableProducts = response.productDetails;
    await checkPremiumStatus();
    debugPrint('Available products: $availableProducts');
  }

  /// Kiểm tra trạng thái Premium khi khởi động ứng dụng
  Future<void> checkPremiumStatus() async {
    final appCache = getIt.get<AppCache>();
    debugPrint("checkPremiumStatus start");
    // Lắng nghe các giao dịch từ purchaseStream

    _iap.purchaseStream.listen((List<PurchaseDetails> purchases) async {
      bool isPremium = false;

      for (var purchase in purchases) {
        debugPrint("checkPremiumStatus: ${purchase.purchaseID} - ${purchase.status}");
        if (_premiumProducts.contains(purchase.productID) &&
            (purchase.status == PurchaseStatus.purchased ||
                purchase.status == PurchaseStatus.restored)) {
          isPremium = true;
          break;
        }
      }

      // Lưu trạng thái Premium
      debugPrint("enablePremiumMember $isPremium");
      await appCache.enablePremiumMember(isPremium);
    }, onError: (error) {
      print('Error in purchase stream: $error');
    });
  }

  /// Lấy trạng thái Premium
  bool isPremium() {
    final appCache = getIt.get<AppCache>();
    return appCache.isPremiumMember();
  }

  /// Mua sản phẩm
  Future<void> purchaseProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    if (product.id.contains('subscription')) {
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } else {
      await _iap.buyConsumable(purchaseParam: purchaseParam, autoConsume: true);
    }
  }

  /// Xử lý giao dịch mua
  Future<void> handlePurchase(PurchaseDetails purchase) async {
    if (purchase.status == PurchaseStatus.purchased) {
      debugPrint('Purchase successful: ${purchase.productID}');

      // Xác nhận giao dịch
      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    } else if (purchase.status == PurchaseStatus.error) {
      debugPrint('Purchase error: ${purchase.error?.message}');
    }
  }

  /// Lấy danh sách sản phẩm từ Google Play
  Future<List<ProductDetails>> fetchProducts() async {
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_premiumProducts.toSet());

    if (response.error == null && response.productDetails.isNotEmpty) {
      return response.productDetails;
    } else {
      print('Error fetching product details: ${response.error}');
      return [];
    }
  }
}
