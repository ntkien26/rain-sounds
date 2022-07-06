import 'package:rain_sounds/data/local/model/mix.dart';

abstract class SleepEvent {}

class RefreshEvent extends SleepEvent {}

class ToggleEvent extends SleepEvent {}

class StopEvent extends SleepEvent {}

class SelectMixEvent extends SleepEvent {

  Mix mix;

  SelectMixEvent({required this.mix});
}