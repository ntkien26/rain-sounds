// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_mix_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomMixModelAdapter extends TypeAdapter<CustomMixModel> {
  @override
  final int typeId = 0;

  @override
  CustomMixModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomMixModel(
      name: fields[0] as String,
      thumbnail: fields[1] as String,
      sounds: (fields[2] as List).cast<SoundModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomMixModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.thumbnail)
      ..writeByte(2)
      ..write(obj.sounds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomMixModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
