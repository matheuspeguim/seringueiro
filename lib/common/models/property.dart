import 'package:cloud_firestore/cloud_firestore.dart';

class Property {
  final String id;
  final String nomeDaPropriedade;
  final int quantidadeDeArvores;
  final String cidade;
  final GeoPoint localizacao; // Tipo GeoPoint para a localização

  Property({
    required this.id,
    required this.nomeDaPropriedade,
    required this.quantidadeDeArvores,
    required this.localizacao,
    required this.cidade,
  });

  factory Property.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Property(
      id: doc.id,
      nomeDaPropriedade: data['nomeDaPropriedade'] ?? '',
      quantidadeDeArvores: data['quantidadeDeArvores'] ?? 0,
      localizacao: data['localizacao'] ??
          GeoPoint(0, 0), // Valor padrão para GeoPoint se for nulo
      cidade: data['cidade'] ?? '',
    );
  }
}
