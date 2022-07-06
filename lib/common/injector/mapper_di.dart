import 'package:get_it/get_it.dart';
import 'package:rain_sounds/domain/mapper/mix_mapper.dart';

import 'app_injector.dart';

class MapperDI {
  MapperDI._();

  static Future<void> init(GetIt injector) async {
    getIt.registerFactory(() => MixMapper());
  }
}
