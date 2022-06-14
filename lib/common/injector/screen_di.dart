import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:rain_sounds/presentation/screens/main/main_screen.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_screen.dart';

class ScreenDI {
  ScreenDI._();

  static Future<void> init(GetIt injector) async {
    injector.registerLazySingleton<Widget>(() => const SplashScreen(),
        instanceName: SplashScreen.routePath);

    injector.registerFactoryParam<Widget, void, void>(
            (_, __) => const MainScreen(),
        instanceName: MainScreen.routePath);
  }
}