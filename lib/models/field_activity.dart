import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/models/activity_point.dart';
import 'package:uuid/uuid.dart';

class FieldActivity {
  String? id;
  DateTime inicio;
  DateTime fim;
  String tabela;
  String atividade;
  String usuarioUid;
  String propertyId;
  Map<String, dynamic> condicoesClimaticas;
  bool finalizada;
  List<ActivityPoint> activityPoints;

  FieldActivity({
    this.id,
    required this.inicio,
    required this.fim,
    required this.tabela,
    required this.atividade,
    required this.usuarioUid,
    required this.propertyId,
    required this.condicoesClimaticas,
    required this.finalizada,
    this.activityPoints = const [],
  });

  static String gerarUuid() {
    // Utilizando a biblioteca uuid para gerar um UUID
    var uuid = Uuid();
    return uuid.v4(); // Gera um UUID versão 4
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'inicio': Timestamp.fromDate(inicio),
      'fim': Timestamp.fromDate(fim),
      'tabela': tabela,
      'atividade': atividade,
      'usuarioUid': usuarioUid,
      'propertyId': propertyId,
      'condicoesClimaticas': condicoesClimaticas,
      'finalizada': finalizada,
      'activityPoints': activityPoints
          .map((activityPoints) => activityPoints.toMap())
          .toList(),
    };
  }

  static FieldActivity fromMap(Map<String, dynamic> map) {
    return FieldActivity(
      id: map['id'],
      inicio: (map['inicio'] as Timestamp).toDate(),
      fim: (map['fim'] as Timestamp).toDate(),
      tabela: map['tabela'],
      atividade: map['atividade'],
      usuarioUid: map['usuarioUid'],
      propertyId: map['propertyId'],
      condicoesClimaticas: map['condicoesClimaticas'],
      finalizada: map['finalizada'] ?? false,
      activityPoints: List<ActivityPoint>.from(
        map['activityPoints'].map((x) => ActivityPoint.fromMap(x)),
      ),
    );
  }
}
