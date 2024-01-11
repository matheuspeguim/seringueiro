import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/activity_point.dart';

class FieldActivity {
  String id;
  DateTime momento;
  Duration duracaoTotal;
  String tabela;
  String usuarioId; // Armazenar o ID do usuário como string
  String propertyId;
  Map<String, dynamic> condicoesClimaticas;
  bool finalizada;
  List<ActivityPoint> activityPoints;

  FieldActivity({
    required this.id,
    required this.momento,
    required this.duracaoTotal,
    required this.tabela,
    required this.usuarioId,
    required this.propertyId,
    required this.condicoesClimaticas,
    required this.finalizada,
    this.activityPoints = const [],
  });

  static String gerarUuid() {
    // Gerando um UUID simples com base no tempo e um número aleatório
    return DateTime.now().millisecondsSinceEpoch.toString() +
        Random().nextInt(99999).toString();
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'momento': Timestamp.fromDate(momento),
      'duracaoTotal': duracaoTotal.inMilliseconds,
      'tabela': tabela,
      'usuarioId': usuarioId,
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
      momento: (map['momento'] as Timestamp).toDate(),
      duracaoTotal: Duration(milliseconds: map['duracaoTotal']),
      tabela: map['tabela'],
      usuarioId: map['usuarioId'],
      propertyId: map['propertyId'],
      condicoesClimaticas: map['condicoesClimaticas'],
      finalizada: map['finalizada'] ?? false,
      activityPoints: List<ActivityPoint>.from(
        map['activityPoints'].map((x) => ActivityPoint.fromMap(x)),
      ),
    );
  }
}
