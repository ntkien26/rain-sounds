// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sound_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SoundModelAdapter extends TypeAdapter<SoundModel> {
  @override
  final int typeId = 1;

  @override
  SoundModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SoundModel(
      id: fields[0] as int,
      name: fields[1] as String?,
      fileName: fields[2] as String?,
      icon: fields[3] as String?,
      volume: fields[4] as double,
      premium: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, SoundModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.fileName)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.volume)
      ..writeByte(5)
      ..write(obj.premium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SoundModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
