import 'package:audioplayers/audioplayers.dart';
import 'package:rain_sounds/data/local/model/sound.dart';
import 'package:rain_sounds/presentation/utils/assets.dart';
import 'package:rain_sounds/presentation/utils/constants.dart';

class AudioManager {
  Map<int, AudioPlayer> playing = {};

  AudioManager();

  play(Sound sound) async {
    print('Play: ${sound.fileName}');
    if (!playing.containsKey(sound.id)) {
      AudioPlayer audioPlayer = AudioPlayer();
      audioPlayer.play(AssetSource('${Assets.baseSoundsPath}${sound.fileName}.ogg'), volume: sound.volume.toDouble());
      playing[sound.id] = audioPlayer;
    }
    playing[sound.id]?.setVolume(sound.volume / Constants.maxSliderValue); // volume applies between 0 and 1
    playing[sound.id]?.resume();
  }

  stop(Sound sound) async {
    if (playing.containsKey(sound.id)) {
      await playing[sound.id]?.stop();
    }
  }
}
