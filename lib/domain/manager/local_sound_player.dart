import 'package:audioplayers/audioplayers.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';

class LocalSoundPlayer {
  Map<int, AudioPlayer> playing = {};

  LocalSoundPlayer();

  play(Sound sound) async {
    print('Play: ${sound.fileName}');
    if (!playing.containsKey(sound.id)) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.setReleaseMode(ReleaseMode.loop);
      audioPlayer.play(
          AssetSource('${Assets.baseSoundsPath}${sound.fileName}.aac'),
          volume: sound.volume);
      playing[sound.id] = audioPlayer;
    }
    // Volume applies between 0 and 1
    playing[sound.id]?.setVolume(sound.volume);
    playing[sound.id]?.resume();
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
    }
  }
}
