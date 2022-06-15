import 'package:rain_sounds/data/local/model/cover.dart';
import 'package:rain_sounds/data/local/model/sound.dart';

import 'package:json_annotation/json_annotation.dart';

part 'mix.g.dart';

@JsonSerializable()
class Mix {

  int? mixSoundId;
  int? category;
  String? name;
  Cover? cover;
  List<Sound>? sounds;

  Mix({this.mixSoundId, this.category, this.name, this.cover, this.sounds});

  factory Mix.fromJson(Map<String, dynamic> json) => _$MixFromJson(json);
}