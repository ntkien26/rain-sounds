import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';

class OnlineMusicPlayer extends BaseAudioHandler {
  final AudioPlayer audioPlayer;
  final PlaybackTimer playbackTimer;

  OnlineMusicPlayer(this.audioPlayer, this.playbackTimer);

  late MusicModel musicModel;

  void setSource(MusicModel musicModel) {
    this.musicModel = musicModel;
  }

  @override
  Future<void> play() async {
    playbackTimer.reset();
    playbackState.add(playbackState.value
        .copyWith(playing: true, controls: [MediaControl.pause]));
    await audioPlayer.play(UrlSource(musicModel.url ?? ''), volume: 100);
    playbackTimer.start();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value
        .copyWith(playing: false, controls: [MediaControl.play]));
    audioPlayer.pause();
    playbackTimer.pause();
  }

  Future<void> resume() async {
    playbackState.add(playbackState.value
        .copyWith(playing: true, controls: [MediaControl.pause]));
    audioPlayer.resume();
    playbackTimer.start();
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value
        .copyWith(playing: false, controls: [MediaControl.stop]));
    audioPlayer.stop();
    audioPlayer.release();
    playbackTimer.off();
  }
}
