import 'package:rain_sounds/data/remote/model/music_model.dart';

abstract class NowPlayingEvent {}

class PlayMusicEvent extends NowPlayingEvent {
  final MusicModel musicModel;
  PlayMusicEvent(this.musicModel);
}

class ToggleEvent extends NowPlayingEvent {}

class StopEvent extends NowPlayingEvent {}

class ToggleLoopEvent extends NowPlayingEvent {}

class SetSleepTimerEvent extends NowPlayingEvent {
  /// null means "Off" — cancel the sleep timer
  final Duration? duration;
  SetSleepTimerEvent(this.duration);
}
