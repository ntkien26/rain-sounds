// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:rain_sounds/common/configs/app_cache.dart';
//
// const String lifetime = 'lifetime';
// const String monthly = 'monthly';
// const String yearly = 'yearly';
//
// const List<String> _kProductIds = <String>[lifetime, monthly, yearly];
//
// class IAPHelper extends ChangeNotifier {
//   final InAppPurchase _inAppPurchase = InAppPurchase.instance;
//   late StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   List<PurchaseDetails> _purchases = [];
//   List<String> _consumables = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String? _queryProductError;
//
//   final AppCache appCache;
//
//   IAPHelper(this.appCache);
//
//   Future<void> initStoreInfo() async {
//     print('initStoreInfo');
//     final bool isAvailable = await _inAppPurchase.isAvailable();
//     print('initStoreInfo: $isAvailable');
//     if (!isAvailable) {
//       _isAvailable = isAvailable;
//       _products = [];
//       _purchases = [];
//       _notFoundIds = [];
//       _consumables = [];
//       _purchasePending = false;
//       _loading = false;
//       return;
//     }
//
//     ProductDetailsResponse productDetailResponse =
//         await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
//     if (productDetailResponse.error != null) {
//       print(
//           'productDetailResponse: ${productDetailResponse.productDetails.length}');
//       _queryProductError = productDetailResponse.error!.message;
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = [];
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = [];
//       _purchasePending = false;
//       _loading = false;
//       return;
//     } else {
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = [];
//       _purchasePending = false;
//       _loading = false;
//     }
//
//     if (productDetailResponse.productDetails.isEmpty) {
//       print('productDetailResponse: isEmpty');
//       _queryProductError = null;
//       _isAvailable = isAvailable;
//       _products = productDetailResponse.productDetails;
//       _purchases = [];
//       _notFoundIds = productDetailResponse.notFoundIDs;
//       _consumables = [];
//       _purchasePending = false;
//       _loading = false;
//       return;
//     }
//
//     final purchaseUpdated = _inAppPurchase.purchaseStream;
//     _subscription = purchaseUpdated.listen(
//       _onPurchaseUpdate,
//       onDone: _updateStreamOnDone,
//       onError: _updateStreamOnError,
//     );
//   }
//
//   Future<void> buy(String productID) async {
//     final productDetails =
//         _products.firstWhere((element) => element.id == productID);
//     final purchaseParam = PurchaseParam(productDetails: productDetails);
//     switch (productID) {
//       case lifetime:
//         await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//         break;
//       case monthly:
//         await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//         break;
//       case yearly:
//       await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
//         break;
//       default:
//         throw ArgumentError.value('$productID is not a known product');
//     }
//   }
//
//   void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
//     print('_onPurchaseUpdate');
//     purchaseDetailsList.forEach(_handlePurchase);
//     notifyListeners();
//   }
//
//   void _handlePurchase(PurchaseDetails purchaseDetails) {
//     if (purchaseDetails.status == PurchaseStatus.purchased) {
//       switch (purchaseDetails.productID) {
//         case lifetime:
//           appCache.enablePremiumMember(true);
//           break;
//         case monthly:
//           final date = DateTime.fromMillisecondsSinceEpoch(int.tryParse(purchaseDetails.transactionDate ?? '') ?? 0);
//           final expireDate = DateTime(date.year, date.month + 1, date.day, date.hour, date.minute);
//           appCache.setExpireDateSubscription(expireDate.millisecondsSinceEpoch);
//           break;
//         case yearly:
//           final date = DateTime.fromMillisecondsSinceEpoch(int.tryParse(purchaseDetails.transactionDate ?? '') ?? 0);
//           final expireDate = DateTime(date.year + 1, date.month, date.day, date.hour, date.minute);
//           appCache.setExpireDateSubscription(expireDate.millisecondsSinceEpoch);
//           break;
//       }
//     }
//
//     if (purchaseDetails.pendingCompletePurchase) {
//       _inAppPurchase.completePurchase(purchaseDetails);
//     }
//   }
//
//   void _updateStreamOnDone() {
//     _subscription.cancel();
//   }
//
//   void _updateStreamOnError(dynamic error) {
//     //Handle error here
//   }
// }
