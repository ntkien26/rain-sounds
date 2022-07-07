import 'package:rain_sounds/data/local/model/mix.dart';

abstract class NowMixPlayingEvent {}

class PlayMixEvent extends NowMixPlayingEvent {

  final Mix mix;
  final bool autoStart;

  PlayMixEvent({required this.mix, required this.autoStart});
}

class ToggleMixEvent extends NowMixPlayingEvent {}
