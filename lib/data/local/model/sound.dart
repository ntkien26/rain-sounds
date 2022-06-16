import 'package:json_annotation/json_annotation.dart';

part 'sound.g.dart';

@JsonSerializable()
class Sound {
  int id;
  String? name;
  String fileName = "";
  String? icon;
  double volume = 80;
  bool active = false;

  Sound(
      {required this.id,
      this.name,
      this.fileName = "",
      this.icon = "",
      this.volume = 80,
      this.active = false});

  Sound copyWith(
      {int? id,
      String? name,
      String? fileName = "",
      String? icon = "",
      double? volume = 80,
      bool? active = false}) {
    return Sound(
        id: id ?? this.id,
        name: name ?? this.name,
        fileName: fileName ?? this.fileName,
        icon: icon ?? this.icon,
        volume: volume ?? this.volume,
        active: active ?? this.active);
  }

  factory Sound.fromJson(Map<String, dynamic> json) => _$SoundFromJson(json);
}
