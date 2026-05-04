import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';

class OnlineMusicPlayer {
  final AssetsAudioPlayer audioPlayer;

  bool isLooping = false;

  Timer? _sleepTimer;
  Duration? _sleepTimerDuration;

  // Callback called every second with remaining sleep time, or null when timer stops
  void Function(Duration? remaining)? onSleepTimerTick;

  OnlineMusicPlayer(this.audioPlayer);

  Future<void> play(MusicModel musicModel) async {
    try {
      await audioPlayer.open(
          Audio.network(musicModel.url ?? '',
              metas: Metas(
                  title: musicModel.title,
                  image: MetasImage(
                      path: musicModel.thumbnail ?? '',
                      type: ImageType.network))),
          showNotification: true,
          loopMode: isLooping ? LoopMode.single : LoopMode.none,
          notificationSettings: const NotificationSettings(
              seekBarEnabled: true, nextEnabled: false, prevEnabled: false));
    } catch (t) {
      // mp3 unreachable
    }
  }

  void toggleLoop() {
    isLooping = !isLooping;
    if (isLooping) {
      audioPlayer.setLoopMode(LoopMode.single);
    } else {
      audioPlayer.setLoopMode(LoopMode.none);
    }
  }

  void setSleepTimer(Duration? duration) {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    _sleepTimerDuration = duration;

    if (duration == null) {
      onSleepTimerTick?.call(null);
      return;
    }

    Duration remaining = duration;
    onSleepTimerTick?.call(remaining);

    _sleepTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = remaining - const Duration(seconds: 1);
      if (remaining <= Duration.zero) {
        timer.cancel();
        _sleepTimer = null;
        _sleepTimerDuration = null;
        audioPlayer.pause();
        onSleepTimerTick?.call(null);
      } else {
        onSleepTimerTick?.call(remaining);
      }
    });
  }

  Future<void> playOrPause() async {
    await audioPlayer.playOrPause();
  }

  Future<void> stop() async {
    _sleepTimer?.cancel();
    _sleepTimer = null;
    await audioPlayer.stop();
    await audioPlayer.dispose();
  }
}
