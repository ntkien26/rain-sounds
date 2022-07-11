import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class LocalSoundPlayer {
  LocalSoundPlayer();

  // final AssetsAudioPlayer playerNotification = AssetsAudioPlayer.withId("1111");

  play(Sound sound) async {
    print('Play: ${sound.fileName}');
    AssetsAudioPlayer audioPlayer =
        AssetsAudioPlayer.withId(sound.id.toString());
    if (audioPlayer.current.hasValue) {
      audioPlayer.play();
    } else {
      await audioPlayer.open(
          Audio('${Assets.baseSoundsPath}${sound.fileName}.aac',
              metas: Metas(title: "Sleep sounds")),
          showNotification: true,
          loopMode: LoopMode.single,
          notificationSettings: const NotificationSettings(
              seekBarEnabled: false, nextEnabled: false, prevEnabled: false));
    }
    await audioPlayer.setVolume(sound.volume / 100);
  }

  pause(Sound sound) async {
    print('Pause: ${sound.fileName}');
    AssetsAudioPlayer audioPlayer =
        AssetsAudioPlayer.withId(sound.id.toString());
    audioPlayer.pause();
  }

  stop(Sound sound) async {
    print('Stop: ${sound.fileName}');
    AssetsAudioPlayer audioPlayer =
        AssetsAudioPlayer.withId(sound.id.toString());
    audioPlayer.stop();
  }
}
