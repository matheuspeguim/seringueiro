// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_temperature.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyTemperatureAdapter extends TypeAdapter<DailyTemperature> {
  @override
  final int typeId = 102;

  @override
  DailyTemperature read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyTemperature(
      day: fields[0] as double,
      min: fields[1] as double,
      max: fields[2] as double,
      night: fields[3] as double,
      eve: fields[4] as double,
      morn: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyTemperature obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.day)
      ..writeByte(1)
      ..write(obj.min)
      ..writeByte(2)
      ..write(obj.max)
      ..writeByte(3)
      ..write(obj.night)
      ..writeByte(4)
      ..write(obj.eve)
      ..writeByte(5)
      ..write(obj.morn);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyTemperatureAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
