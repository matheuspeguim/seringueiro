// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_alert.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherAlertAdapter extends TypeAdapter<WeatherAlert> {
  @override
  final int typeId = 106;

  @override
  WeatherAlert read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherAlert(
      senderName: fields[0] as String,
      event: fields[1] as String,
      start: fields[2] as int,
      end: fields[3] as int,
      description: fields[4] as String,
      tags: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, WeatherAlert obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.senderName)
      ..writeByte(1)
      ..write(obj.event)
      ..writeByte(2)
      ..write(obj.start)
      ..writeByte(3)
      ..write(obj.end)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherAlertAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
