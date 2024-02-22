import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityPoint {
  final String
      id; // Considerando o uso de String se IDs forem UUIDs ou gerados pelo Firestore
  final DateTime momento;
  final double latitude;
  final double longitude;
  final String fieldActivityId;

  ActivityPoint({
    required this.id,
    required this.momento,
    required this.latitude,
    required this.longitude,
    required this.fieldActivityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'momento':
          Timestamp.fromDate(momento), // Convertendo DateTime para Timestamp
      'latitude': latitude,
      'longitude': longitude,
      'fieldActivityId': fieldActivityId,
    };
  }

  // Método fromMap com conversão correta de Timestamp para DateTime
  factory ActivityPoint.fromMap(Map<String, dynamic> map) {
    return ActivityPoint(
      id: map['id'],
      momento: (map['momento'] as Timestamp)
          .toDate(), // Convertendo Timestamp para DateTime
      latitude: map['latitude'],
      longitude: map['longitude'],
      fieldActivityId: map['fieldActivityId'],
    );
  }
}
