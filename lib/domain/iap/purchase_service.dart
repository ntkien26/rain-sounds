import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rxdart/rxdart.dart';

class PurchaseService {
  static const API_KEY = 'appl_PIbSzXmGdkZRobdcFJgkhHwYVHK';

  List<String> skus = ['monthly', 'yearly', 'lifetime'];

  final AppCache appCache = getIt.get();

  final BehaviorSubject<List<Product>> _products =
      BehaviorSubject<List<Product>>.seeded(List.empty());

  ValueStream<List<Product>> get products => _products.stream;

  final BehaviorSubject<bool> _purchaseUpdated =
  BehaviorSubject<bool>.seeded(false);

  ValueStream<bool> get purchaseUpdated => _purchaseUpdated.stream;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(API_KEY);
    _products.add(await Purchases.getProducts(skus));
    final purchaseInfo = await Purchases.getPurchaserInfo();

    if (!appCache.isLifetimePremium()) {
      print('User doesnt have lifetime premium currently');
      if (purchaseInfo.activeSubscriptions.isEmpty) {
        print('No active subscriptions');
        appCache.activeSubscription(false);
      } else {
        print(
            'Active subscriptions ${purchaseInfo.activeSubscriptions.length}');
        appCache.activeSubscription(true);
      }
    } else {
      print('User has lifetime premium currently');
    }
  }

  Future<bool> buy(String sku) async {
    try {
      await Purchases.purchaseProduct(sku);
      if (sku == 'monthly' || sku == 'yearly') {
        appCache.activeSubscription(true);
      } else {
        appCache.enablePremiumMember(true);
      }
      _purchaseUpdated.add(true);
      return true;
    } catch (ex) {
      return false;
    }
  }

  Future<void> close() async {
    await Purchases.close();
  }
}
