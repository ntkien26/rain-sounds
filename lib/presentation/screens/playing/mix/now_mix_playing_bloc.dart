import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_state.dart';

import 'now_mix_playing_event.dart';

class NowMixPlayingBloc extends Bloc<NowMixPlayingEvent, NowMixPlayingState> {
  final SoundService soundService;

  NowMixPlayingBloc(this.soundService) : super(NowMixPlayingState.initial) {
    on(_onNowMixPlayingEvent);
  }

  Future<void> _onNowMixPlayingEvent(
      NowMixPlayingEvent event, Emitter<NowMixPlayingState> emit) async {

    if (event is PlayMixEvent) {
      await soundService.playSounds(event.mix.sounds ?? List.empty());
      emit(state.copyWith(isPlaying: true));
    } else if (event is ToggleMixEvent) {
      if (soundService.isPlaying) {
        await soundService.pauseAllPlayingSounds();
        emit(state.copyWith(isPlaying: soundService.isPlaying));
      } else {
        await soundService.playAllSelectedSounds();
        emit(state.copyWith(isPlaying: soundService.isPlaying));
      }
    }
  }
}
