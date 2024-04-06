import 'package:hive/hive.dart';

part 'weather_condition.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(typeId: 2)
class WeatherCondition extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String main;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String icon;

  WeatherCondition({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      id: json['id'],
      main: json['main'],
      description: json['description'],
      icon: json['icon'],
    );
  }
}
