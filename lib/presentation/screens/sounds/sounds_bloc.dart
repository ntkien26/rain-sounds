import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/common/injector/app_injector.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/domain/manager/notification_manager.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {
  final SoundService soundService;
  final PlaybackTimer timerController;
  final NotificationService notificationService = getIt.get();

  SoundsBloc({required this.soundService, required this.timerController})
      : super(SoundsState.initial) {
    _fetchSound();
    on<SoundsEvent>(_onSoundEvent);
    soundService.isPlaying.listen((isPlaying) {
      emit(state.copyWith(isPlaying: isPlaying));
    });
  }

  Future<void> _fetchSound() async {
    emit(state.copyWith(
        status: SoundsStatus.success,
        sounds: soundService.sounds,
        isPlaying: soundService.isPlaying.value,
        totalSelected: soundService.totalActiveSound));
  }

  Future<void> _onSoundEvent(
      SoundsEvent event, Emitter<SoundsState> emit) async {
    if (event is UpdateSound) {
      await soundService.updateSound(event.soundId, event.active, event.volume);
      emit(state.copyWith(
          status: SoundsStatus.update,
          totalSelected: soundService.totalActiveSound,
          isPlaying: soundService.isPlaying.value));
    } else if (event is ToggleSoundsEvent) {
      if (soundService.isPlaying.value) {
        await soundService.pauseAllPlayingSounds();
      } else {
        await soundService.playAllSelectedSounds();
      }
      emit(state.copyWith(isPlaying: soundService.isPlaying.value));
    } else if (event is RefreshEvent) {
      _fetchSound();
    }
  }
}
