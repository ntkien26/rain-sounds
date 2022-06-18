import 'package:rain_sounds/data/local/model/mix.dart';

abstract class NowMixPlayingEvent {}

class PlayMixEvent extends NowMixPlayingEvent {

  final Mix mix;

  PlayMixEvent(this.mix);
}

class ToggleMixEvent extends NowMixPlayingEvent {}
