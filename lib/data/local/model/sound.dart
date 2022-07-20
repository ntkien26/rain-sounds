import 'package:json_annotation/json_annotation.dart';

part 'sound.g.dart';

@JsonSerializable()
class Sound {
  int id;
  String? name;
  String? fileName;
  String? icon;
  double volume = 80;
  String? extension;
  bool active = false;
  bool premium = false;

  Sound(
      {required this.id,
      this.name,
      this.fileName,
      this.icon,
      this.volume = 80,
      this.extension,
      this.active = false,
      this.premium = false});

  Sound copyWith(
      {int? id,
      String? name,
      String? fileName,
      String? icon,
      double? volume = 80,
      String? extension,
      bool? active = false,
      bool? premium = false}) {
    return Sound(
        id: id ?? this.id,
        name: name ?? this.name,
        fileName: fileName ?? this.fileName,
        icon: icon ?? this.icon,
        volume: volume ?? this.volume,
        extension: extension ?? this.extension,
        active: active ?? this.active,
        premium: premium ?? this.premium);
  }

  factory Sound.fromJson(Map<String, dynamic> json) => _$SoundFromJson(json);
}
