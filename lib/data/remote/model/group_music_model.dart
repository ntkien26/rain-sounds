import 'package:json_annotation/json_annotation.dart';
import 'package:rain_sounds/data/remote/model/music_model.dart';

part 'group_music_model.g.dart';

@JsonSerializable()
class GroupMusicModel {
  String? group;
  String? description;
  List<MusicModel>? items;

  GroupMusicModel({this.group, this.description, this.items});

  factory GroupMusicModel.fromJson(Map<String, dynamic> json) => _$GroupMusicModelFromJson(json);
}