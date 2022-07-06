import 'package:hive/hive.dart';
import 'package:rain_sounds/data/local/hive_model/sound_model.dart';

part 'custom_mix_model.g.dart';

@HiveType(typeId: 0)
class CustomMixModel extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String thumbnail;

  @HiveField(2)
  List<SoundModel> sounds;

  CustomMixModel(
      {required this.name, required this.thumbnail, required this.sounds});
}
