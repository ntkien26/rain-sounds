// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_music_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMusicModel _$GroupMusicModelFromJson(Map<String, dynamic> json) =>
    GroupMusicModel(
      group: json['group'] as String?,
      description: json['description'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => MusicModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GroupMusicModelToJson(GroupMusicModel instance) =>
    <String, dynamic>{
      'group': instance.group,
      'description': instance.description,
      'items': instance.items,
    };
