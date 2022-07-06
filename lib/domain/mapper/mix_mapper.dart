import 'package:rain_sounds/data/local/hive_model/custom_mix_model.dart';
import 'package:rain_sounds/data/local/model/cover.dart';
import 'package:rain_sounds/data/local/model/mix.dart';
import 'package:rain_sounds/data/local/model/sound.dart';

class MixMapper {

  Mix mapMix(CustomMixModel model) {
    return Mix(
        mixSoundId: createUniqueId(),
        category: 1,
        name: model.name,
        cover: Cover(thumbnail: model.thumbnail, background: model.thumbnail),
        sounds: model.sounds
            .map((e) => Sound(
                id: e.id,
                name: e.name,
                fileName: e.fileName,
                volume: e.volume,
                premium: e.premium))
            .toList());
  }

  int createUniqueId() {
    return DateTime.now().millisecondsSinceEpoch.remainder(100000);
  }
}
