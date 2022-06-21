import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {
  final SoundService soundService;
  final TimerController timerController;

  SoundsBloc({required this.soundService, required this.timerController})
      : super(SoundsState.initial) {
    _fetchSound();
    on<SoundsEvent>(_onSoundEvent);
  }

  Future<void> _fetchSound() async {
    emit(state.copyWith(
        status: SoundsStatus.success,
        sounds: soundService.sounds,
        isPlaying: soundService.isPlaying,
        totalSelected: soundService.totalActiveSound));
  }

  Future<void> _onSoundEvent(
      SoundsEvent event, Emitter<SoundsState> emit) async {
    if (event is UpdateSound) {
      await soundService.updateSound(event.soundId, event.active, event.volume);
      emit(state.copyWith(
          status: SoundsStatus.update,
          totalSelected: soundService.totalActiveSound,
          isPlaying: soundService.isPlaying));
    } else if (event is ToggleSoundsEvent) {
      if (soundService.isPlaying) {
        await soundService.pauseAllPlayingSounds();
      } else {
        await soundService.playAllSelectedSounds();
      }
      emit(state.copyWith(isPlaying: soundService.isPlaying));
    }
  }
}
