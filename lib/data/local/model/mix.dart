import 'package:json_annotation/json_annotation.dart';
import 'package:rain_sounds/data/local/model/cover.dart';
import 'package:rain_sounds/data/local/model/sound.dart';

part 'mix.g.dart';

@JsonSerializable()
class Mix {
  int mixSoundId;
  int? category;
  String? name;
  Cover? cover;
  List<Sound>? sounds;

  bool? premium = false;

  Mix(
      {required this.mixSoundId,
      this.category,
      this.name,
      this.cover,
      this.sounds,
      this.premium});

  Mix copyWith(
      {int? mixSoundId,
      int? category,
      String? name,
      Cover? cover,
      List<Sound>? sounds,
      bool? premium}) {
    return Mix(
        mixSoundId: mixSoundId ?? this.mixSoundId,
        category: category ?? this.category,
        name: name ?? this.name,
        cover: cover ?? this.cover,
        sounds: sounds ?? this.sounds,
        premium: premium ?? this.premium);
  }

  factory Mix.fromJson(Map<String, dynamic> json) => _$MixFromJson(json);
}
