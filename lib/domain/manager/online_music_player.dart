import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';
import 'package:rain_sounds/domain/manager/playback_timer.dart';

class OnlineMusicPlayer {
  final AssetsAudioPlayer audioPlayer;
  final PlaybackTimer playbackTimer;

  OnlineMusicPlayer(this.audioPlayer, this.playbackTimer) {
    audioPlayer.isPlaying.listen((isPlaying) {
      if (isPlaying) {
        playbackTimer.start();
      } else {
        playbackTimer.pause();
      }
    });
  }

  Future<void> play(MusicModel musicModel) async {
    playbackTimer.reset();
    try {
      await audioPlayer.open(
          Audio.network(musicModel.url ?? '',
              metas: Metas(
                  title: musicModel.title,
                  image: MetasImage(
                      path: musicModel.thumbnail ?? '',
                      type: ImageType.network))),
          showNotification: true,
          notificationSettings: const NotificationSettings(
              seekBarEnabled: false, nextEnabled: false, prevEnabled: false));
      playbackTimer.start();
    } catch (t) {
      //mp3 unreachable
    }
  }

  Future<void> playOrPause() async {
    await audioPlayer.playOrPause();
  }

  Future<void> stop() async {
    await audioPlayer.stop();
    await audioPlayer.dispose();
    playbackTimer.off();
    playbackTimer.reset();
  }
}
