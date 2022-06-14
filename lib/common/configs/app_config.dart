import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/presentation/base/base_stateful_widget.dart';

class AppConfig {
  AppConfig._();

  factory AppConfig() {
    return _appConfig;
  }

  static final AppConfig _appConfig = AppConfig._();

  Future<void> configApp() async {
    WidgetsFlutterBinding.ensureInitialized();
    await AppInjector.initializeDependencies();
  }

}