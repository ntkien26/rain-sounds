import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class LocalSoundPlayer {
  Map<int, AssetsAudioPlayer> playing = {};

  LocalSoundPlayer();

  play(Sound sound) async {
    print('Play: ${sound.fileName}');
    if (!playing.containsKey(sound.id)) {
      AssetsAudioPlayer audioPlayer = AssetsAudioPlayer.newPlayer();
      await audioPlayer.open(
        Audio('${Assets.baseSoundsPath}${sound.fileName}.aac'),
        showNotification: true,
        loopMode: LoopMode.single,
        notificationSettings: const NotificationSettings(
          seekBarEnabled: false,
          nextEnabled: false,
          prevEnabled: false
        )
      );
      await audioPlayer.setVolume(sound.volume);
      playing[sound.id] = audioPlayer;
    }
    // Volume applies between 0 and 1
    playing[sound.id]?.setVolume(sound.volume);
    playing[sound.id]?.play();
  }

  pause(Sound sound) async {
    print('Pause: ${sound.fileName}');
    if (playing.containsKey(sound.id)) {
      await playing[sound.id]?.pause();
    }
  }

  stop(Sound sound) async {
    print('Stop: ${sound.fileName}');
    if (playing.containsKey(sound.id)) {
      await playing[sound.id]?.stop();
      await playing[sound.id]?.dispose();
    }
  }
}
