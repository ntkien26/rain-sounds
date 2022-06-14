import 'package:json_annotation/json_annotation.dart';

part 'music_json_model.g.dart';

@JsonSerializable()
class MusicJsonModel {
  int? id = 0;
  String? title = "";
  String? premium = "";
  String? group = "";
  String? url = "";
  String? thumbnail = "";
  String? background = "";
  String? badge = "";

  MusicJsonModel({this.id, this.title, this.premium, this.group, this.url,
    this.thumbnail, this.background, this.badge});

  factory MusicJsonModel.fromJson(Map<String, dynamic> json) => _$MusicJsonModelFromJson(json);
  Map<String, dynamic> toJson() => _$MusicJsonModelToJson(this);
}