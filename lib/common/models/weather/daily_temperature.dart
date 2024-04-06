// Exemplo para DailyTemperature

import 'package:hive_flutter/hive_flutter.dart';

part 'daily_temperature.g.dart';

@HiveType(typeId: 102) // Use um ID único
class DailyTemperature extends HiveObject {
  @HiveField(0)
  final double day;
  @HiveField(1)
  final double min;
  @HiveField(2)
  final double max;
  @HiveField(3)
  final double night;
  @HiveField(4)
  final double eve;
  @HiveField(5)
  final double morn;

  DailyTemperature({
    required this.day,
    required this.min,
    required this.max,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory DailyTemperature.fromJson(Map<String, dynamic> json) {
    return DailyTemperature(
      day: json['day'].toDouble(),
      min: json['min'].toDouble(),
      max: json['max'].toDouble(),
      night: json['night'].toDouble(),
      eve: json['eve'].toDouble(),
      morn: json['morn'].toDouble(),
    );
  }
}
