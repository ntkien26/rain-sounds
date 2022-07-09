import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/online_music_player.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final OnlineMusicPlayer onlineMusicPlayer;

  NowPlayingBloc(this.onlineMusicPlayer) : super(NowPlayingState.initial) {
    on(_onNowPlayingEvent);
    onlineMusicPlayer.audioPlayer.isPlaying.listen((isPlaying) {
      emit(state.copyWith(isPlaying: isPlaying));
    });
  }

  Future<void> _onNowPlayingEvent(
      NowPlayingEvent event, Emitter<NowPlayingState> emit) async {
    if (event is PlayMusicEvent) {
      final SoundService soundService = getIt.get();
      if (soundService.isPlaying.value) {
        await soundService.stopAllPlayingSounds();
      }
      await onlineMusicPlayer.play(event.musicModel);
    } else if (event is ToggleEvent) {
      await onlineMusicPlayer.playOrPause();
    } else if (event is StopEvent) {
      await onlineMusicPlayer.stop();
    }
  }
}
