// Exemplo para DailyFeelsLike

import 'package:hive_flutter/hive_flutter.dart';

part 'daily_feels_like.g.dart';

@HiveType(typeId: 103) // Use um ID único
class DailyFeelsLike extends HiveObject {
  @HiveField(0)
  final double day;
  @HiveField(1)
  final double night;
  @HiveField(2)
  final double eve;
  @HiveField(3)
  final double morn;

  DailyFeelsLike({
    required this.day,
    required this.night,
    required this.eve,
    required this.morn,
  });

  factory DailyFeelsLike.fromJson(Map<String, dynamic> json) {
    return DailyFeelsLike(
      day: json['day'].toDouble(),
      night: json['night'].toDouble(),
      eve: json['eve'].toDouble(),
      morn: json['morn'].toDouble(),
    );
  }
}
