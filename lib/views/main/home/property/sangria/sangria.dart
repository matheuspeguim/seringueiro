import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Sangria {
  String id;
  DateTime momento;
  Duration duracaoTotal;
  String tabela;
  String usuarioId; // Armazenar o ID do usuário como string
  String propertyId;
  Map<String, dynamic> condicoesClimaticas;
  bool finalizada;
  List<PontoDeSangria> pontos;

  Sangria({
    required this.id,
    required this.momento,
    required this.duracaoTotal,
    required this.tabela,
    required this.usuarioId,
    required this.propertyId,
    required this.condicoesClimaticas,
    required this.finalizada,
    this.pontos = const [],
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
      'pontos': pontos.map((ponto) => ponto.toMap()).toList(),
    };
  }

  static Sangria fromMap(Map<String, dynamic> map) {
    return Sangria(
      id: map['id'],
      momento: (map['momento'] as Timestamp).toDate(),
      duracaoTotal: Duration(milliseconds: map['duracaoTotal']),
      tabela: map['tabela'],
      usuarioId: map['usuarioId'],
      propertyId: map['propertyId'],
      condicoesClimaticas: map['condicoesClimaticas'],
      finalizada: map['finalizada'] ?? false,
      pontos: List<PontoDeSangria>.from(
        map['pontos'].map((x) => PontoDeSangria.fromMap(x)),
      ),
    );
  }
}

// Métodos para converter de/para um mapa (para uso com Firestore)

class PontoDeSangria {
  int id;
  DateTime timestamp;
  LatLng localizacao;
  int duracao;
  String sangriaId; // ID da Sangria à qual este ponto pertence

  PontoDeSangria({
    required this.id,
    required this.timestamp,
    required this.localizacao,
    required this.duracao,
    required this.sangriaId, // Incluir sangriaId como um campo obrigatório
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': Timestamp.fromDate(timestamp),
      'localizacao': GeoPoint(localizacao.latitude, localizacao.longitude),
      'duracao': duracao,
      'sangriaId': sangriaId,
    };
  }

  static PontoDeSangria fromMap(Map<String, dynamic> map) {
    GeoPoint geoPoint = map['localizacao'];
    return PontoDeSangria(
      id: map['id'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      localizacao: LatLng(geoPoint.latitude, geoPoint.longitude),
      duracao: map['duracao'],
      sangriaId: map['sangriaId'],
    );
  }
}
