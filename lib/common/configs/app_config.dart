import 'package:rain_sounds/common/injector/app_injector.dart';

class AppConfig {
  AppConfig._();

  factory AppConfig() {
    return _appConfig;
  }

  static final AppConfig _appConfig = AppConfig._();

  Future<void> configApp() async {
    await AppInjector.initializeDependencies();
  }

}