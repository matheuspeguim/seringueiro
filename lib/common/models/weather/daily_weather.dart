import 'package:flutter_seringueiro/common/models/weather/weather_condition.dart';
import 'package:hive/hive.dart';
import 'daily_temperature.dart';
import 'daily_feels_like.dart';

part 'daily_weather.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(typeId: 101) // Lembre-se, o typeId precisa ser único
class DailyWeather extends HiveObject {
  @HiveField(0)
  final int dt;
  @HiveField(1)
  final int sunrise;
  @HiveField(2)
  final int sunset;
  @HiveField(3)
  final int moonrise;
  @HiveField(4)
  final int moonset;
  @HiveField(5)
  final double moonPhase;
  @HiveField(6)
  final String summary;
  @HiveField(7)
  final DailyTemperature temp;
  @HiveField(8)
  final DailyFeelsLike feelsLike;
  @HiveField(9)
  final int pressure;
  @HiveField(10)
  final int humidity;
  @HiveField(11)
  final double dewPoint;
  @HiveField(12)
  final double windSpeed;
  @HiveField(13)
  final int windDeg;
  @HiveField(14)
  final double windGust;
  @HiveField(15)
  final List<WeatherCondition>
      weather; // Certifique-se de que WeatherCondition esteja preparado para o Hive
  @HiveField(16)
  final int clouds;
  @HiveField(17)
  final double pop;
  @HiveField(18)
  final double rain;
  @HiveField(19)
  final double uvi;
  @HiveField(20)
  final double dailyPrecipitation;

  DailyWeather({
    required this.dt,
    required this.sunrise,
    required this.sunset,
    required this.moonrise,
    required this.moonset,
    required this.moonPhase,
    required this.summary,
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.dewPoint,
    required this.windSpeed,
    required this.windDeg,
    required this.windGust,
    required this.weather,
    required this.clouds,
    required this.pop,
    required this.rain,
    required this.uvi,
    required this.dailyPrecipitation,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      dt: json['dt'],
      sunrise: json['sunrise'],
      sunset: json['sunset'],
      moonrise: json['moonrise'],
      moonset: json['moonset'],
      moonPhase: json['moon_phase'].toDouble(),
      summary: json['summary'], // Assumed custom field
      temp: DailyTemperature.fromJson(json['temp']),
      feelsLike: DailyFeelsLike.fromJson(json['feels_like']),
      pressure: json['pressure'],
      humidity: json['humidity'],
      dewPoint: json['dew_point'].toDouble(),
      windSpeed: json['wind_speed'].toDouble(),
      windDeg: json['wind_deg'],
      windGust: json['wind_gust'].toDouble(),
      weather: List<WeatherCondition>.from(
          json['weather'].map((x) => WeatherCondition.fromJson(x))),
      clouds: json['clouds'],
      pop: json['pop'].toDouble(),
      rain: json['rain']?.toDouble() ?? 0, // Optional field
      uvi: json['uvi'].toDouble(),
      dailyPrecipitation:
          json['rain']?.toDouble() ?? json['snow']?.toDouble() ?? 0.0,
    );
  }
}
