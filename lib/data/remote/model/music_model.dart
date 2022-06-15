import 'package:json_annotation/json_annotation.dart';

part 'music_model.g.dart';

@JsonSerializable()
class MusicModel {
  int? id = 0;
  String? title = "";
  bool? premium = false;
  String? group = "";
  String? url = "";
  String? thumbnail = "";
  String? background = "";
  String? badge = "";

  MusicModel({this.id, this.title, this.premium, this.group, this.url,
    this.thumbnail, this.background, this.badge});

  factory MusicModel.fromJson(Map<String, dynamic> json) => _$MusicModelFromJson(json);
  Map<String, dynamic> toJson() => _$MusicModelToJson(this);
}