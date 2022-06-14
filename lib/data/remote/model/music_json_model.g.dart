// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_json_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicJsonModel _$MusicJsonModelFromJson(Map<String, dynamic> json) =>
    MusicJsonModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      premium: json['premium'] as String?,
      group: json['group'] as String?,
      url: json['url'] as String?,
      thumbnail: json['thumbnail'] as String?,
      background: json['background'] as String?,
      badge: json['badge'] as String?,
    );

Map<String, dynamic> _$MusicJsonModelToJson(MusicJsonModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'premium': instance.premium,
      'group': instance.group,
      'url': instance.url,
      'thumbnail': instance.thumbnail,
      'background': instance.background,
      'badge': instance.badge,
    };
