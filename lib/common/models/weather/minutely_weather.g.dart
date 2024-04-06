// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'minutely_weather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MinutelyWeatherAdapter extends TypeAdapter<MinutelyWeather> {
  @override
  final int typeId = 105;

  @override
  MinutelyWeather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MinutelyWeather(
      dt: fields[0] as int,
      precipitation: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, MinutelyWeather obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dt)
      ..writeByte(1)
      ..write(obj.precipitation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MinutelyWeatherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
