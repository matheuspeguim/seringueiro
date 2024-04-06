// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_feels_like.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyFeelsLikeAdapter extends TypeAdapter<DailyFeelsLike> {
  @override
  final int typeId = 103;

  @override
  DailyFeelsLike read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyFeelsLike(
      day: fields[0] as double,
      night: fields[1] as double,
      eve: fields[2] as double,
      morn: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyFeelsLike obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.night)
      ..writeByte(2)
      ..write(obj.eve)
      ..writeByte(3)
      ..write(obj.morn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyFeelsLikeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
