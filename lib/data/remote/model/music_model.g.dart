// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MusicModel _$MusicModelFromJson(Map<String, dynamic> json) => MusicModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      premium: json['premium'] as bool?,
      group: json['group'] as String?,
      url: json['url'] as String?,
      thumbnail: json['thumbnail'] as String?,
      background: json['background'] as String?,
      badge: json['badge'] as String?,
    );

Map<String, dynamic> _$MusicModelToJson(MusicModel instance) =>
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
