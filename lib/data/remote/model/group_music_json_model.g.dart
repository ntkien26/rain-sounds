// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_music_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMusicJsonModel _$GroupMusicJsonModelFromJson(Map<String, dynamic> json) =>
    GroupMusicJsonModel(
      group: json['group'] as String?,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MusicJsonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupMusicJsonModelToJson(
        GroupMusicJsonModel instance) =>
    <String, dynamic>{
      'group': instance.group,
      'description': instance.description,
      'items': instance.items,
    };
