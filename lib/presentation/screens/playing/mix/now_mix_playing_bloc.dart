import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/now_mix_playing_state.dart';

import 'now_mix_playing_event.dart';

class NowMixPlayingBloc extends Bloc<NowMixPlayingEvent, NowMixPlayingState> {
  final SoundService soundService;

  NowMixPlayingBloc(this.soundService) : super(NowMixPlayingState.initial) {
    on(_onNowMixPlayingEvent);
    soundService.isPlaying.listen((isPlaying) {
      emit(state.copyWith(isPlaying: isPlaying));
    });
  }

  Future<void> _onNowMixPlayingEvent(
      NowMixPlayingEvent event, Emitter<NowMixPlayingState> emit) async {
    if (event is PlayMixEvent) {
      if (event.autoStart) {
        Mix mix = await soundService.getMix(event.mix.mixSoundId);
        await soundService.playMix(mix);
      }
      final selectedSound = await soundService.getSelectedSounds();
      event.mix.sounds?.clear();
      event.mix.sounds?.insertAll(0, selectedSound);
      emit(state.copyWith(isPlaying: true, mix: event.mix));
    } else if (event is ToggleMixEvent) {
      if (soundService.isPlaying.value) {
        await soundService.pauseAllPlayingSounds();
      } else {
        await soundService.playAllSelectedSounds();
      }
    }
  }
}
