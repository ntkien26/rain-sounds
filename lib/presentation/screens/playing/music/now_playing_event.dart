import 'package:rain_sounds/data/remote/model/music_model.dart';

abstract class NowPlayingEvent {}

class PlayMusicEvent extends NowPlayingEvent {

  final MusicModel musicModel;

  PlayMusicEvent(this.musicModel);
}

class ToggleEvent extends NowPlayingEvent {}
