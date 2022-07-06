import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:rain_sounds/data/local/hive_model/custom_mix_model.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/domain/mapper/mix_mapper.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';

class SleepBloc extends Bloc<SleepEvent, SleepState> {
  final SoundService soundService;
  final Box<CustomMixModel> box;
  final MixMapper mapper;

  SleepBloc(
      {required this.soundService, required this.box, required this.mapper})
      : super(SleepState.initial) {
    loadMixes();
  }

  Future<void> loadMixes() async {
    emit(state.copyWith(status: SleepStatus.loading));
    final List<Mix> allMix = List.empty(growable: true);
    final mixes = await soundService.loadMixes();
    final customMix = box.values.map((e) => mapper.mapMix(e)).toList();
    allMix.addAll(customMix);
    allMix.addAll(mixes);
    if (mixes.isEmpty) {
      emit(state.copyWith(status: SleepStatus.empty));
      return;
    }

    emit(state.copyWith(status: SleepStatus.success, mixes: allMix));
  }
}
