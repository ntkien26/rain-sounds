import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_event.dart';
import 'package:rain_sounds/presentation/screens/sleep/sleep_state.dart';

class SleepBloc extends Bloc<SleepEvent, SleepState>{

  final SoundService soundService;

  SleepBloc(this.soundService) : super(SleepState.initial) {
    loadMixes();
  }

  Future<void> loadMixes() async {
    emit(state.copyWith(status: SleepStatus.loading));

    final mixes = await soundService.loadMixes();

    if (mixes.isEmpty) {
      emit(state.copyWith(status: SleepStatus.empty));
      return;
    }

    emit(state.copyWith(status: SleepStatus.success, mixes: mixes));
  }
}