class ActivityPoint {
  final int id;
  final int timestamp;
  final double latitude;
  final double longitude;
  final int duracao;
  final String fieldActivityId;

  ActivityPoint({
    required this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.duracao,
    required this.fieldActivityId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'duracao': duracao,
      'fieldActivityId': fieldActivityId,
    };
  }

  // Método fromMap
  factory ActivityPoint.fromMap(Map<String, dynamic> map) {
    return ActivityPoint(
      id: map['id'],
      timestamp: map['timestamp'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      duracao: map['duracao'],
      fieldActivityId: map['fieldActivityId'],
    );
  }
}
