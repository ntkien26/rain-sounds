import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/domain/manager/timer_controller.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_event.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_state.dart';

class EditSelectedSoundBloc extends Bloc<EditSelectedSoundEvent, EditSelectedSoundState> {
  final SoundService soundService;
  final TimerController timerController;

  EditSelectedSoundBloc({required this.soundService, required this.timerController})
      : super(EditSelectedSoundState.initial) {
    _fetchSound();
    on<EditSelectedSoundEvent>(_onEditSelectedSoundEvent);
  }

  Future<void> _fetchSound() async {
    final selected = await soundService.getSelectedSounds();
    emit(state.copyWith(
        status: EditSelectedSoundStatus.success,
        selectedSounds: selected,
        sounds: soundService.sounds,)
    );
  }

  Future<void> _onEditSelectedSoundEvent(
      EditSelectedSoundEvent event, Emitter<EditSelectedSoundState> emit) async {
    if (event is UpdateSound) {
      await soundService.updateSound(event.soundId, event.active, event.volume);
      emit(state.copyWith(
          status: EditSelectedSoundStatus.update,));
    } else if (event is RefreshEvent) {
      _fetchSound();
    }
  }
}
