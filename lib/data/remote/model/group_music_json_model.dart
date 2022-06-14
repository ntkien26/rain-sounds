import 'package:json_annotation/json_annotation.dart';
import 'package:rain_sounds/data/remote/model/music_json_model.dart';

part 'group_music_json_model.g.dart';

@JsonSerializable()
class GroupMusicJsonModel {
  String? group;
  String? description;
  List<MusicJsonModel>? items;

  GroupMusicJsonModel({this.group, this.description, this.items});

  factory GroupMusicJsonModel.fromJson(Map<String, dynamic> json) => _$GroupMusicJsonModelFromJson(json);
}