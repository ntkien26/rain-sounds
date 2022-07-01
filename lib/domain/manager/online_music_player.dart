import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';

class OnlineMusicPlayer extends BaseAudioHandler {
  final AudioPlayer audioPlayer;

  OnlineMusicPlayer(this.audioPlayer);

  late MusicModel musicModel;

  void setSource(MusicModel musicModel) {
    this.musicModel = musicModel;
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value
        .copyWith(playing: true, controls: [MediaControl.pause]));
    audioPlayer.play(UrlSource(musicModel.url ?? ''), volume: 100);
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value
        .copyWith(playing: false, controls: [MediaControl.play]));
    audioPlayer.pause();
  }

  Future<void> resume() async {
    playbackState.add(playbackState.value
        .copyWith(playing: true, controls: [MediaControl.pause]));
    audioPlayer.resume();
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value
        .copyWith(playing: false, controls: [MediaControl.stop]));
    audioPlayer.stop();
    audioPlayer.release();
  }
}
