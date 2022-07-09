import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rain_sounds/data/local/hive_model/custom_mix_model.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/domain/mapper/mix_mapper.dart';
import 'package:rain_sounds/domain/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';

class SleepBloc extends Bloc<SleepEvent, SleepState> {
  final SoundService soundService;
  final Box<CustomMixModel> box;
  final MixMapper mapper;

  SleepBloc(
      {required this.soundService, required this.box, required this.mapper})
      : super(SleepState.initial) {
    _loadMixes();
    on<SleepEvent>(_onSleepEvent);
  }

  Future<void> _onSleepEvent(SleepEvent event, Emitter<SleepState> emit) async {
    if (event is RefreshEvent) {
      _loadMixes();
    } else if (event is ToggleEvent) {
      if (soundService.isPlaying.value) {
        soundService.pauseAllPlayingSounds();
      } else {
        soundService.playAllSelectedSounds();
      }
    } else if (event is StopEvent) {
      soundService.stopMix();
      emit(state.copyWith(showBottomMedia: false));
    } else if (event is SelectMixEvent) {
      emit(state.copyWith(selectedMix: event.mix, showBottomMedia: true));
    }
  }

  Future<void> _loadMixes() async {
    emit(state.copyWith(status: SleepStatus.loading));
    List<Category> categories = [
      Category(id: 0, title: 'All'),
      Category(id: 2, title: 'Sleep'),
      Category(id: 3, title: 'Rain'),
      Category(id: 4, title: 'Relax'),
      Category(id: 5, title: 'Meditation'),
      Category(id: 6, title: 'Work'),
    ];
    final List<Mix> allMix = List.empty(growable: true);
    final mixes = await soundService.loadMixes();
    final customMix = box.values.map((e) => mapper.mapMix(e)).toList();
    allMix.addAll(customMix);
    allMix.addAll(mixes);
    if (mixes.isEmpty) {
      emit(state.copyWith(status: SleepStatus.empty));
      return;
    }

    if (customMix.isNotEmpty) {
      categories.insert(1, Category(id: 1, title: 'Custom'));
    }

    emit(state.copyWith(
        status: SleepStatus.success, mixes: allMix, categories: categories));
  }
}
