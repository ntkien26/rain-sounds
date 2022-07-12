import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rain_sounds/data/local/hive_model/custom_mix_model.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';
import 'package:rain_sounds/domain/mapper/mix_mapper.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_event.dart';
import 'package:rain_sounds/presentation/screens/playing/mix/edit_selected_sound/edit_selected_sound_state.dart';

class EditSelectedSoundBloc
    extends Bloc<EditSelectedSoundEvent, EditSelectedSoundState> {
  final SoundService soundService;
  final PlaybackTimer timerController;
  final Box<CustomMixModel> box;
  final MixMapper mixMapper;

  EditSelectedSoundBloc(
      {required this.soundService,
      required this.timerController,
      required this.box,
      required this.mixMapper})
      : super(EditSelectedSoundState.initial) {
    _fetchSound();
    on<EditSelectedSoundEvent>(_onEditSelectedSoundEvent);
  }

  Future<void> _fetchSound() async {
    final selected = await soundService.getSelectedSounds();
    emit(state.copyWith(
      status: EditSelectedSoundStatus.success,
      selectedSounds: selected,
      sounds: soundService.sounds,
    ));
  }

  Future<void> reset(Mix mix) async {
    try {
      final resetMix = await soundService.getMix(mix.mixSoundId);
      await soundService.playMix(resetMix);
    } catch (e) {
      final resetMix =
          box.values.firstWhere((element) => element.name == mix.name);
      await soundService.playMix(mixMapper.mapMix(resetMix));
    }
    final selected = await soundService.getSelectedSounds();
    emit(state.copyWith(
      status: EditSelectedSoundStatus.success,
      selectedSounds: selected,
      sounds: soundService.sounds,
    ));
  }

  Future<void> _onEditSelectedSoundEvent(EditSelectedSoundEvent event,
      Emitter<EditSelectedSoundState> emit) async {
    if (event is UpdateSound) {
      await soundService.updateSound(event.soundId, event.active, event.volume);
      final selected = await soundService.getSelectedSounds();
      emit(state.copyWith(
        selectedSounds: selected,
        status: EditSelectedSoundStatus.update,
      ));
    } else if (event is RefreshEvent) {
      _fetchSound();
    } else if (event is ResetEvent) {
      reset(event.mix);
    }
  }
}
