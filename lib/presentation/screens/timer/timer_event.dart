import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent([List props = const []]) : super();
}

class Start extends TimerEvent {
  final int duration;

  Start({required this.duration}) : super([duration]);

  @override
  String toString() => "Start { duration: $duration }";

  @override
  List<Object?> get props => const [];
}

class Pause extends TimerEvent {
  @override
  String toString() => "Pause";

  @override
  List<Object?> get props => const [];
}

class Resume extends TimerEvent {
  @override
  String toString() => "Resume";

  @override
  List<Object?> get props => const [];
}

class Reset extends TimerEvent {
  @override
  String toString() => "Reset";

  @override
  List<Object?> get props => const [];
}

class Tick extends TimerEvent {
  final int duration;

  Tick({required this.duration}) : super([duration]);

  @override
  String toString() => "Tick { duration: $duration }";

  @override
  List<Object?> get props => const [];
}