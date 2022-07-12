import 'package:get_it/get_it.dart';
import 'package:rain_sounds/presentation/app/app_bloc.dart';
import 'package:rain_sounds/presentation/screens/main/main_bloc.dart';
import 'package:rain_sounds/presentation/screens/music/music_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_bloc.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_bloc.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_bloc.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_bloc.dart';
import 'package:rain_sounds/presentation/screens/splash/splash_bloc.dart';

class BlocDI {
  BlocDI._();

  static Future<void> init(GetIt injector) async {
    injector.registerLazySingleton<AppBloc>(() => AppBloc());
    injector.registerFactory<SplashBloc>(() => SplashBloc());
    injector.registerFactory<MainBloc>(() => MainBloc());
    injector
        .registerFactory<MusicBloc>(() => MusicBloc(musicService: injector()));
    injector.registerFactory<SleepBloc>(() => SleepBloc(
        soundService: injector(), box: injector(), mapper: injector()));
    injector.registerFactory<SoundsBloc>(() =>
        SoundsBloc(soundService: injector(), timerController: injector()));
    injector.registerFactory<NowMixPlayingBloc>(
        () => NowMixPlayingBloc(injector()));
    injector.registerFactory<NowPlayingBloc>(() => NowPlayingBloc(injector()));
    injector.registerFactory<EditSelectedSoundBloc>(() => EditSelectedSoundBloc(
        soundService: injector(), timerController: injector(), mixMapper: injector(), box: injector()));
  }
}
