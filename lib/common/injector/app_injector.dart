import 'package:get_it/get_it.dart';
import 'package:rain_sounds/common/injector/app_di.dart';
import 'package:rain_sounds/common/injector/bloc_di.dart';
import 'package:rain_sounds/common/injector/mapper_di.dart';
import 'package:rain_sounds/common/injector/network_di.dart';
import 'package:rain_sounds/common/injector/screen_di.dart';
import 'package:rain_sounds/common/injector/service_di.dart';

final GetIt getIt = GetIt.instance;

class AppInjector {
  AppInjector._();

  static final GetIt injector = GetIt.instance;

  static Future<void> initializeDependencies() async {
    await AppDI.init(injector);
    await MapperDI.init(injector);
    await NetworkDI.init(injector);
    await ServiceDI.init(injector);
    await ScreenDI.init(injector);
    await BlocDI.init(injector);
  }
}