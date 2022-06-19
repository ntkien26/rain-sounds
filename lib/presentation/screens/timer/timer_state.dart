import 'package:meta/meta.dart';

enum TimerStatus { ready, running, pause, end }

@immutable
class TimerState {
  final Duration? duration;
  final TimerStatus? status;

  const TimerState({this.status, this.duration});

  TimerState copyWith({TimerStatus? status, Duration? duration}) {
    return TimerState(
      status: status ?? this.status,
      duration: duration ?? this.duration,
    );
  }

  static TimerState initial = const TimerState();
}
