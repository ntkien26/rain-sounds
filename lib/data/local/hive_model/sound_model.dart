import 'package:hive/hive.dart';

part 'sound_model.g.dart';

@HiveType(typeId: 1)
class SoundModel extends HiveObject {
  @HiveField(0)
  int id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String? fileName;

  @HiveField(3)
  String? icon;

  @HiveField(4)
  double volume = 80;

  @HiveField(5)
  bool premium;

  SoundModel({
    required this.id,
    this.name,
    this.fileName,
    this.icon,
    required this.volume,
    required this.premium,
  });
}
