import 'package:flutter_seringueiro/common/models/weather/weather_condition.dart';
import 'package:hive/hive.dart';

part 'current_weather.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(
    typeId: 1) // typeId deve ser único para cada tipo de classe armazenável
class CurrentWeather extends HiveObject {
  @HiveField(0)
  final int dt;

  @HiveField(1)
  final int sunrise;

  @HiveField(2)
  final int sunset;

  @HiveField(3)
  final double temp;

  @HiveField(4)
  final double feelsLike;

  @HiveField(5)
  final int pressure;

  @HiveField(6)
  final int humidity;

  @HiveField(7)
  final double dewPoint;

  @HiveField(8)
  final double uvi;

  @HiveField(9)
  final int clouds;

  @HiveField(10)
  final int visibility;

  @HiveField(11)
  final double windSpeed;

  @HiveField(12)
  final int windDeg;

  @HiveField(13)
  final double windGust;

  @HiveField(
      14) // Certifique-se de que WeatherCondition esteja anotado para o Hive
  final List<WeatherCondition> weather;

  CurrentWeather({
    required this.dt,
    required this.sunrise,
    required this.sunset,
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
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
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
      windGust: json['wind_gust'].toDouble(),
      weather: List<WeatherCondition>.from(
          json['weather'].map((x) => WeatherCondition.fromJson(x))),
    );
  }
}
