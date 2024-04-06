import 'package:flutter_seringueiro/common/models/weather/current_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/daily_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/hourly_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/minutely_weather.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_alert.dart';
import 'package:hive/hive.dart';

part 'weather_response.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(typeId: 107) // Lembre-se, o typeId deve ser único
class WeatherResponse extends HiveObject {
  @HiveField(0)
  final double lat;

  @HiveField(1)
  final double lon;

  @HiveField(2)
  final String timezone;

  @HiveField(3)
  final int timezoneOffset;

  @HiveField(4)
  final CurrentWeather current;

  @HiveField(5)
  final List<MinutelyWeather> minutely;

  @HiveField(6)
  final List<HourlyWeather> hourly;

  @HiveField(7)
  final List<DailyWeather> daily;

  @HiveField(8)
  final List<WeatherAlert> alerts;

  @HiveField(9) // Novo campo para o timestamp
  int timestamp;

  WeatherResponse({
    required this.lat,
    required this.lon,
    required this.timezone,
    required this.timezoneOffset,
    required this.current,
    required this.minutely,
    required this.hourly,
    required this.daily,
    required this.alerts,
    this.timestamp = 0, // Adicionado ao construtor
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      lat: json['lat'],
      lon: json['lon'],
      timezone: json['timezone'],
      timezoneOffset: json['timezone_offset'],
      current: CurrentWeather.fromJson(json['current']),
      minutely: List<MinutelyWeather>.from(
          json['minutely']?.map((x) => MinutelyWeather.fromJson(x)) ?? []),
      hourly: List<HourlyWeather>.from(
          json['hourly']?.map((x) => HourlyWeather.fromJson(x)) ?? []),
      daily: List<DailyWeather>.from(
          json['daily']?.map((x) => DailyWeather.fromJson(x)) ?? []),
      alerts: json['alerts'] != null
          ? List<WeatherAlert>.from(
              json['alerts'].map((x) => WeatherAlert.fromJson(x)))
          : [],
    );
  }
}
