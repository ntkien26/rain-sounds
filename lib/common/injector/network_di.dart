import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rain_sounds/common/configs/network_config.dart';
import 'package:rain_sounds/data/remote/api/music_api.dart';

import 'app_injector.dart';

export 'app_injector.dart';

class NetworkDI {
  NetworkDI._();

  static Future<void> init(GetIt injector) async {
    getIt.registerLazySingleton<Dio>(() {
      return Dio(
        BaseOptions(
          baseUrl: NetworkConfig.baseUrl,
          connectTimeout: NetworkConfig.connectTimeout,
          receiveTimeout: NetworkConfig.receiveTimeout,
        ),
      );
    });

    getIt.registerLazySingleton<MusicAPI>(() {
      return MusicAPI(getIt.get());
    });
  }
}
