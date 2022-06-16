import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_event.dart';
import 'package:rain_sounds/presentation/screens/sounds/sounds_state.dart';

class SoundsBloc extends Bloc<SoundsEvent, SoundsState> {

  final SoundService soundService;

  SoundsBloc(this.soundService) : super(SoundsState.initial) {
    emit(SoundsState(status: SoundsStatus.success, sounds: soundService.sounds));
    on<SoundsEvent>(_onSoundEvent);
  }

  Future<void> _onSoundEvent(
      SoundsEvent event, Emitter<SoundsState> emit) async {
    if (event is UpdateSound) {
      print('Update Sound');
      soundService.updateSound(event.soundId, event.active, event.volume);
    }
  }
}