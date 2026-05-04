import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/domain/manager/online_music_player.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_event.dart';
import 'package:rain_sounds/presentation/screens/playing/music/now_playing_state.dart';

class NowPlayingBloc extends Bloc<NowPlayingEvent, NowPlayingState> {
  final OnlineMusicPlayer onlineMusicPlayer;

  NowPlayingBloc(this.onlineMusicPlayer) : super(NowPlayingState.initial) {
    on<PlayMusicEvent>(_onPlayMusic);
    on<ToggleEvent>(_onToggle);
    on<StopEvent>(_onStop);
    on<ToggleLoopEvent>(_onToggleLoop);
    on<SetSleepTimerEvent>(_onSetSleepTimer);

    onlineMusicPlayer.audioPlayer.isPlaying.listen((isPlaying) {
      if (!isClosed) emit(state.copyWith(isPlaying: isPlaying));
    });

    onlineMusicPlayer.onSleepTimerTick = (remaining) {
      if (!isClosed) {
        if (remaining == null) {
          emit(state.copyWith(clearSleepTimer: true));
        } else {
          emit(state.copyWith(sleepTimerRemaining: remaining));
        }
      }
    };
  }

  Future<void> _onPlayMusic(
      PlayMusicEvent event, Emitter<NowPlayingState> emit) async {
    final SoundService soundService = getIt.get();
    if (soundService.isPlaying.value) {
      await soundService.stopAllPlayingSounds();
    }
    await onlineMusicPlayer.play(event.musicModel);
    emit(state.copyWith(isLooping: onlineMusicPlayer.isLooping));
  }

  Future<void> _onToggle(ToggleEvent event, Emitter<NowPlayingState> emit) async {
    await onlineMusicPlayer.playOrPause();
  }

  Future<void> _onStop(StopEvent event, Emitter<NowPlayingState> emit) async {
    await onlineMusicPlayer.stop();
  }

  Future<void> _onToggleLoop(
      ToggleLoopEvent event, Emitter<NowPlayingState> emit) async {
    onlineMusicPlayer.toggleLoop();
    emit(state.copyWith(isLooping: onlineMusicPlayer.isLooping));
  }

  Future<void> _onSetSleepTimer(
      SetSleepTimerEvent event, Emitter<NowPlayingState> emit) async {
    onlineMusicPlayer.setSleepTimer(event.duration);
    if (event.duration == null) {
      emit(state.copyWith(clearSleepTimer: true));
    } else {
      emit(state.copyWith(sleepTimerRemaining: event.duration));
    }
  }

  @override
  Future<void> close() {
    onlineMusicPlayer.onSleepTimerTick = null;
    return super.close();
  }
}
