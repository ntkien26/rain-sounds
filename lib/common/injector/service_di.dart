import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get_it/get_it.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/data/remote/service/music_service.dart';
import 'package:rain_sounds/domain/manager/local_sound_player.dart';
import 'package:rain_sounds/domain/manager/online_music_player.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/base/navigation_service.dart';

class ServiceDI {
  ServiceDI._();

  static Future<void> init(GetIt injector) async {
    injector
        .registerLazySingleton<NavigationService>(() => NavigationService());
    injector
        .registerLazySingleton<MusicService>(() => MusicService(injector()));
    injector.registerLazySingleton<LocalSoundPlayer>(() => LocalSoundPlayer());
    injector.registerFactory<OnlineMusicPlayer>(
        () => OnlineMusicPlayer(AssetsAudioPlayer.newPlayer(), injector()));
    injector.registerLazySingleton<PlaybackTimer>(
        () => PlaybackTimer(appCache: injector()));
    injector.registerSingleton<SoundService>(SoundService(
          localSoundManager: injector(), playbackTimer: injector()),
    );
  }
}
