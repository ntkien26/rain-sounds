import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
import 'package:rain_sounds/common/utils/in_app_purchase_helper.dart';
import 'package:rain_sounds/data/local/hive_model/custom_mix_model.dart';
import 'package:rain_sounds/data/local/hive_model/sound_model.dart';
import 'package:rain_sounds/domain/iap/purchase_service.dart';
import 'package:rain_sounds/domain/manager/notification_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDI {
  AppDI._();

  static Future<void> init(GetIt injector) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<AppCache>(() {
      return AppCache(sharedPreferences);
    });
    getIt.registerLazySingleton<AdHelper>(() {
      return AdHelper();
    });
    getIt.registerLazySingleton<NotificationService>(() {
      return NotificationService();
    });
    getIt.registerLazySingleton<PurchaseService>(() {
      return PurchaseService();
    });
    getIt.registerSingletonAsync<Box<CustomMixModel>>(
        () => openHiveBox('custom_mix'));
  }

  static Future<Box<CustomMixModel>> openHiveBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      Hive.init((await getApplicationDocumentsDirectory()).path);
    }

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CustomMixModelAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(SoundModelAdapter());
    }

    return await Hive.openBox<CustomMixModel>(boxName);
  }
}
