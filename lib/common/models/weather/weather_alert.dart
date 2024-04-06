import 'package:hive/hive.dart';

part 'weather_alert.g.dart'; // Este arquivo será gerado pelo hive_generator

@HiveType(typeId: 106) // Lembre-se, o typeId deve ser único
class WeatherAlert extends HiveObject {
  @HiveField(0)
  final String senderName;

  @HiveField(1)
  final String event;

  @HiveField(2)
  final int start;

  @HiveField(3)
  final int end;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final List<String>
      tags; // Hive não suporta listas de strings diretamente; pode precisar de uma abordagem customizada

  WeatherAlert({
    required this.senderName,
    required this.event,
    required this.start,
    required this.end,
    required this.description,
    required this.tags,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      senderName: json['sender_name'],
      event: json['event'],
      start: json['start'],
      end: json['end'],
      description: json['description'],
      tags: List<String>.from(json['tags'].map((x) => x)),
    );
  }
}
