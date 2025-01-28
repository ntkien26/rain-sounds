import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchaseManager {
  final InAppPurchase _iap = InAppPurchase.instance;
  final List<String> _productIds = [
    'monthly_subscription_premium',
    'yearly_subscription',
    'lifetime_access',
  ];

  List<ProductDetails> availableProducts = [];

  Stream<List<PurchaseDetails>> get purchaseStream => _iap.purchaseStream;

  /// Khởi tạo IAP
  Future<void> initialize() async {
    final bool isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      debugPrint('IAP is not available');
      return;
    }

    // Lấy danh sách sản phẩm từ Google Play / App Store
    final ProductDetailsResponse response =
        await _iap.queryProductDetails(_productIds.toSet());
    if (response.error != null) {
      debugPrint('Error fetching products: ${response.error}');
      return;
    }

    availableProducts = response.productDetails;
    debugPrint('Available products: $availableProducts');
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
}
