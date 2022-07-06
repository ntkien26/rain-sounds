import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/domain/manager/online_music_player.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final OnlineMusicPlayer onlineMusicPlayer;

  NowPlayingBloc(this.onlineMusicPlayer) : super(NowPlayingState.initial) {
    on(_onNowPlayingEvent);
  }

  Future<void> _onNowPlayingEvent(
      NowPlayingEvent event, Emitter<NowPlayingState> emit) async {
    if (event is PlayMusicEvent) {
      await onlineMusicPlayer.play(event.musicModel);
    } else if (event is ToggleEvent) {
      await onlineMusicPlayer.playOrPause();
    } else if (event is StopEvent) {
      await onlineMusicPlayer.stop();
    }
  }
}
