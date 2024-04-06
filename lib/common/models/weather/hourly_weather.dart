import 'package:flutter_seringueiro/common/models/weather/weather_condition.dart';
import 'package:hive/hive.dart';

part 'hourly_weather.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(typeId: 104) // typeId deve ser único
class HourlyWeather extends HiveObject {
  @HiveField(0)
  final int dt;

  @HiveField(1)
  final double temp;

  @HiveField(2)
  final double feelsLike;

  @HiveField(3)
  final int pressure;

  @HiveField(4)
  final int humidity;

  @HiveField(5)
  final double dewPoint;

  @HiveField(6)
  final double uvi;

  @HiveField(7)
  final int clouds;

  @HiveField(8)
  final int visibility;

  @HiveField(9)
  final double windSpeed;

  @HiveField(10)
  final int windDeg;

  @HiveField(11)
  final double windGust;

  @HiveField(12)
  final List<WeatherCondition>
      weather; // Garanta que WeatherCondition esteja anotado e adaptado para o Hive

  @HiveField(13)
  final double pop; // Probability of precipitation

  @HiveField(14)
  final double precipitation;

  HourlyWeather({
    required this.dt,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.uvi,
    required this.clouds,
    required this.visibility,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
    required this.pop,
    required this.precipitation,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      dt: json['dt'],
      temp: json['temp'].toDouble(),
      feelsLike: json['feels_like'].toDouble(),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      uvi: json['uvi'].toDouble(),
      clouds: json['clouds'],
      visibility: json['visibility'],
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      windGust: json['wind_gust']?.toDouble() ?? 0, // Optional field
      weather: List<WeatherCondition>.from(
          json['weather'].map((x) => WeatherCondition.fromJson(x))),
      pop: json['pop'].toDouble(),
      precipitation: json['rain']?['1h']?.toDouble() ??
          json['snow']?['1h']?.toDouble() ??
          0.0,
    );
  }
}
