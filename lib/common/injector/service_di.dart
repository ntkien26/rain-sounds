import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/data/remote/service/music_service.dart';
import 'package:rain_sounds/domain/manager/local_sound_player.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';

class ServiceDI {
  ServiceDI._();

  static Future<void> init(GetIt injector) async {
    injector
        .registerLazySingleton<NavigationService>(() => NavigationService());
    injector
        .registerLazySingleton<MusicService>(() => MusicService(injector()));
    injector.registerLazySingleton<LocalSoundPlayer>(() => LocalSoundPlayer());
    injector.registerLazySingleton<TimerController>(
        () => TimerController(appCache: injector()));
    injector.registerSingleton<SoundService>(await AudioService.init(
      builder: () => SoundService(
          localSoundManager: injector(), timerController: injector()),
    ));
  }
}
