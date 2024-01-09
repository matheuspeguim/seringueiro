class PontoDeSangria {
  final int id;
  final int timestamp;
  final double latitude;
  final double longitude;
  final int duracao;
  final String sangriaId;

  PontoDeSangria({
    required this.id,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.duracao,
    required this.sangriaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': timestamp,
      'latitude': latitude,
      'longitude': longitude,
      'duracao': duracao,
      'sangriaId': sangriaId,
    };
  }
}
