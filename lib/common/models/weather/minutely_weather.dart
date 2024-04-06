import 'package:hive/hive.dart';

part 'minutely_weather.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(
    typeId: 105) // O typeId deve ser único entre todos os tipos armazenáveis
class MinutelyWeather extends HiveObject {
  @HiveField(0)
  final int dt;

  @HiveField(1)
  final double precipitation;

  MinutelyWeather({
    required this.dt,
    required this.precipitation,
  });

  factory MinutelyWeather.fromJson(Map<String, dynamic> json) {
    return MinutelyWeather(
      dt: json['dt'],
      precipitation: json['precipitation'].toDouble(),
    );
  }
}
