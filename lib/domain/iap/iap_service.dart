import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';

class IAPService {
  /// To listen the status of connection between app and the billing server
  late StreamSubscription<ConnectionResult> _connectionSubscription;

  /// To listen the status of the purchase made inside or outside of the app (App Store / Play Store)
  ///
  /// If status is not error then app will be notied by this stream
  late StreamSubscription<PurchasedItem?> purchaseUpdatedSubscription;

  /// To listen the errors of the purchase
  late StreamSubscription<PurchaseResult?> purchaseErrorSubscription;

  /// List of product ids you want to fetch
  final List<String> _productIds = ['lifetime', 'monthly', 'yearly'];

  /// All available products will be store in this list
  List<IAPItem>? _products;

  /// All past purchases will be store in this list
  List<PurchasedItem> _pastPurchases = [];

  final AppCache appCache = getIt.get();

  /// view of the app will subscribe to this to get notified
  /// when premium status of the user changes
  final ObserverList<Function> _proStatusChangedListeners =
      ObserverList<Function>();

  /// view of the app will subscribe to this to get errors of the purchase
  final ObserverList<Function(String)> _errorListeners =
      ObserverList<Function(String)>();

  /// logged in user's premium status
  bool _isProUser = false;

  bool get isProUser => _isProUser;

  static const String lifetime = 'lifetime';
  static const String monthly = 'monthly';
  static const String yearly = 'yearly';

  /// Call this method at the startup of you app to initialize connection
  /// with billing server and get all the necessary data
  void initConnection() async {
    await FlutterInappPurchase.instance.initialize();
    _connectionSubscription =
        FlutterInappPurchase.connectionUpdated.listen((connected) {});

    purchaseUpdatedSubscription =
        FlutterInappPurchase.purchaseUpdated.listen(_handlePurchaseUpdate);

    purchaseErrorSubscription =
        FlutterInappPurchase.purchaseError.listen(_handlePurchaseError);

    _getItems();
    _checkSubscribed();
  }

  Future<List<IAPItem>?> get products async {
    if (_products == null) {
      await _getItems();
    }
    return _products;
  }

  Future<void> _getItems() async {
    List<IAPItem> items =
        await FlutterInappPurchase.instance.getSubscriptions(_productIds);
    _products = List.empty(growable: true);
    for (var item in items) {
      _products?.add(item);
    }
  }

  void _getPastPurchases() async {
    List<PurchasedItem>? purchasedItems =
        await FlutterInappPurchase.instance.getAvailablePurchases();
    if (purchasedItems != null) {
      _isProUser = true;
      _callProStatusChangedListeners();
      _pastPurchases = List.empty(growable: true);
      _pastPurchases.addAll(purchasedItems);
      for (var purchasedItem in purchasedItems) {
        print(
            'purchasedItem: ${purchasedItem.productId} - ${purchasedItem.transactionDate?.toIso8601String()}');
      }
    } else {
      print('No past purchase');
    }
  }

  void _checkSubscribed() async {
    final isMonthlyActive =
        await FlutterInappPurchase.instance.checkSubscribed(sku: monthly);
    final isYearlyActive =
        await FlutterInappPurchase.instance.checkSubscribed(sku: yearly, duration: const Duration(days: 365));
    if (isMonthlyActive || isYearlyActive) {
      await appCache.activeSubscription(true);
    } else {
      await appCache.activeSubscription(false);
    }
  }

  Future<void> requestPurchase(String productId) async {
    try {
      await FlutterInappPurchase.instance.requestPurchase(productId);
    } catch (error) {
      //Ignore
    }
  }

  Future<void> requestSubscription(String productId) async {
    try {
      await FlutterInappPurchase.instance.requestSubscription(productId);
    } catch (error) {
      //Ignore
    }
  }

  /// Called when new updates arrives at ``purchaseUpdated`` stream
  void _handlePurchaseUpdate(PurchasedItem? productItem) async {
    if (productItem != null) {
      if (Platform.isAndroid) {
        // await _handlePurchaseUpdateAndroid(productItem);
      } else {
        await _handlePurchaseUpdateIOS(productItem);
      }
    }
  }

  Future<void> _handlePurchaseUpdateIOS(PurchasedItem purchasedItem) async {
    switch (purchasedItem.transactionStateIOS) {
      case TransactionState.deferred:
        // Edit: This was a bug that was pointed out here : https://github.com/dooboolab/flutter_inapp_purchase/issues/234
        // FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.failed:
        _callErrorListeners("Transaction Failed");
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      case TransactionState.purchased:
        await _verifyAndFinishTransaction(purchasedItem);
        break;
      case TransactionState.purchasing:
        break;
      case TransactionState.restored:
        FlutterInappPurchase.instance.finishTransaction(purchasedItem);
        break;
      default:
    }
  }

  void _handlePurchaseError(PurchaseResult? purchaseError) {
    _callErrorListeners(purchaseError?.message ?? '');
  }

  /// Call this method when status of purchase is success
  /// Call API of your back end to verify the reciept
  /// back end has to call billing server's API to verify the purchase token
  _verifyAndFinishTransaction(PurchasedItem purchasedItem) async {
    FlutterInappPurchase.instance.finishTransaction(purchasedItem);
    _isProUser = true;
    appCache.enablePremiumMember(true);
    _callProStatusChangedListeners();
  }

  /// call when user close the app
  void dispose() {
    _connectionSubscription.cancel();
    purchaseErrorSubscription.cancel();
    purchaseUpdatedSubscription.cancel();
    FlutterInappPurchase.instance.finalize();
  }

  /// Call this method to notify all the subsctibers of _proStatusChangedListeners
  void _callProStatusChangedListeners() {
    _proStatusChangedListeners.forEach((Function callback) {
      callback();
    });
  }

  /// Call this method to notify all the subsctibers of _errorListeners
  void _callErrorListeners(String error) {
    _errorListeners.forEach((Function callback) {
      callback(error);
    });
  }

  /// view can subscribe to _proStatusChangedListeners using this method
  addToProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.add(callback);
  }

  /// view can cancel to _proStatusChangedListeners using this method
  removeFromProStatusChangedListeners(Function callback) {
    _proStatusChangedListeners.remove(callback);
  }
}
