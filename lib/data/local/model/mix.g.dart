// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mix.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mix _$MixFromJson(Map<String, dynamic> json) => Mix(
      mixSoundId: json['mixSoundId'] as int?,
      category: json['category'] as int?,
      name: json['name'] as String?,
      cover: json['cover'] == null
          ? null
          : Cover.fromJson(json['cover'] as Map<String, dynamic>),
      sounds: (json['sounds'] as List<dynamic>?)
          ?.map((e) => Sound.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MixToJson(Mix instance) => <String, dynamic>{
      'mixSoundId': instance.mixSoundId,
      'category': instance.category,
      'name': instance.name,
      'cover': instance.cover,
      'sounds': instance.sounds,
    };
