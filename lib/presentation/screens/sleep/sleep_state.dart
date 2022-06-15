import 'package:rain_sounds/data/local/model/mix.dart';

enum SleepStatus { loading, success, empty, error }

class SleepState {

  const SleepState({this.status = SleepStatus.empty, this.mixes});

  final SleepStatus status;
  final List<Mix>? mixes;

  SleepState copyWith(
      {SleepStatus? status, List<Mix>? mixes}) {
    return SleepState(status: status ?? this.status, mixes: mixes);
  }

  static SleepState initial = const SleepState();
}