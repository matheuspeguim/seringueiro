// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WeatherResponseAdapter extends TypeAdapter<WeatherResponse> {
  @override
  final int typeId = 107;

  @override
  WeatherResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WeatherResponse(
      lat: fields[0] as double,
      lon: fields[1] as double,
      timezone: fields[2] as String,
      timezoneOffset: fields[3] as int,
      current: fields[4] as CurrentWeather,
      minutely: (fields[5] as List).cast<MinutelyWeather>(),
      hourly: (fields[6] as List).cast<HourlyWeather>(),
      daily: (fields[7] as List).cast<DailyWeather>(),
      alerts: (fields[8] as List).cast<WeatherAlert>(),
      timestamp: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WeatherResponse obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.lat)
      ..writeByte(1)
      ..write(obj.lon)
      ..writeByte(2)
      ..write(obj.timezone)
      ..writeByte(3)
      ..write(obj.timezoneOffset)
      ..writeByte(4)
      ..write(obj.current)
      ..writeByte(5)
      ..write(obj.minutely)
      ..writeByte(6)
      ..write(obj.hourly)
      ..writeByte(7)
      ..write(obj.daily)
      ..writeByte(8)
      ..write(obj.alerts)
      ..writeByte(9)
      ..write(obj.timestamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeatherResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
