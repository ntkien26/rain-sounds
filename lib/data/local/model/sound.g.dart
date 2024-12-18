// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sound _$SoundFromJson(Map<String, dynamic> json) => Sound(
      id: json['id'] as int,
      name: json['name'] as String?,
      fileName: json['fileName'] as String?,
      icon: json['icon'] as String?,
      volume: (json['volume'] as num?)?.toDouble() ?? 80,
      extension: json['extension'] as String?,
      active: json['active'] as bool? ?? false,
      premium: json['premium'] as bool? ?? false,
    );

Map<String, dynamic> _$SoundToJson(Sound instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'fileName': instance.fileName,
      'icon': instance.icon,
      'volume': instance.volume,
      'extension': instance.extension,
      'active': instance.active,
      'premium': instance.premium,
    };
