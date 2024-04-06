// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_weather.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DailyWeatherAdapter extends TypeAdapter<DailyWeather> {
  @override
  final int typeId = 101;

  @override
  DailyWeather read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyWeather(
      dt: fields[0] as int,
      sunrise: fields[1] as int,
      sunset: fields[2] as int,
      moonrise: fields[3] as int,
      moonset: fields[4] as int,
      moonPhase: fields[5] as double,
      summary: fields[6] as String,
      temp: fields[7] as DailyTemperature,
      feelsLike: fields[8] as DailyFeelsLike,
      pressure: fields[9] as int,
      humidity: fields[10] as int,
      dewPoint: fields[11] as double,
      windSpeed: fields[12] as double,
      windDeg: fields[13] as int,
      windGust: fields[14] as double,
      weather: (fields[15] as List).cast<WeatherCondition>(),
      clouds: fields[16] as int,
      pop: fields[17] as double,
      rain: fields[18] as double,
      uvi: fields[19] as double,
      dailyPrecipitation: fields[20] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyWeather obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.dt)
      ..writeByte(1)
      ..write(obj.sunrise)
      ..writeByte(2)
      ..write(obj.sunset)
      ..writeByte(3)
      ..write(obj.moonrise)
      ..writeByte(4)
      ..write(obj.moonset)
      ..writeByte(5)
      ..write(obj.moonPhase)
      ..writeByte(6)
      ..write(obj.summary)
      ..writeByte(7)
      ..write(obj.temp)
      ..writeByte(8)
      ..write(obj.feelsLike)
      ..writeByte(9)
      ..write(obj.pressure)
      ..writeByte(10)
      ..write(obj.humidity)
      ..writeByte(11)
      ..write(obj.dewPoint)
      ..writeByte(12)
      ..write(obj.windSpeed)
      ..writeByte(13)
      ..write(obj.windDeg)
      ..writeByte(14)
      ..write(obj.windGust)
      ..writeByte(15)
      ..write(obj.weather)
      ..writeByte(16)
      ..write(obj.clouds)
      ..writeByte(17)
      ..write(obj.pop)
      ..writeByte(18)
      ..write(obj.rain)
      ..writeByte(19)
      ..write(obj.uvi)
      ..writeByte(20)
      ..write(obj.dailyPrecipitation);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyWeatherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
