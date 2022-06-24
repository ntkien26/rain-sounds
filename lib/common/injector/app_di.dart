import 'package:get_it/get_it.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/common/utils/ad_helper.dart';
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
  }
}
