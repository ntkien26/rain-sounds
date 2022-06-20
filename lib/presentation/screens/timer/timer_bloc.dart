import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rain_sounds/common/configs/app_cache.dart';
import 'package:rain_sounds/data/local/service/sound_service.dart';
import 'package:rain_sounds/presentation/screens/timer/timer_event.dart';
import 'package:rain_sounds/presentation/screens/timer/timer_state.dart';
import 'package:rain_sounds/presentation/utils/duration_util.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  late Timer timer;
  final AppCache appCache;
  final SoundService soundService;

  late int remainingTime;

  TimerBloc({required this.appCache, required this.soundService})
      : super(TimerState.initial) {
    on(_onTimerEvent);
  }

  Future<void> _onTimerEvent(TimerEvent event, Emitter<TimerState> emit) async {
    if (event is Start) {
      Duration duration = parseTime(
          appCache.getTimer() ?? const Duration(minutes: 30).toString());

      if (soundService.isPlaying) {
        timer = Timer.periodic(duration, (timer) {
          remainingTime = duration.inSeconds - timer.tick;
          emit(state.copyWith(
              status: TimerStatus.running,
              duration: Duration(seconds: remainingTime)));
        });
      }
    } else if (event is Pause) {
      if (timer.isActive) {
        timer.cancel();
      }
    } else if (event is Resume) {
      final duration = Duration(seconds: remainingTime);
      timer = Timer.periodic(duration, (timer) {
        remainingTime = duration.inSeconds - timer.tick;
        emit(state.copyWith(
            status: TimerStatus.running,
            duration: Duration(seconds: remainingTime)));
      });
    }
  }
}
