// new_property_event.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class NewPropertyEvent extends Equatable {
  const NewPropertyEvent();

  @override
  List<Object> get props => [];
}

class NewPropertyAddStart extends NewPropertyEvent {}

class NewPropertySubmit extends NewPropertyEvent {
  final String nomeDaPropriedade;
  final double areaEmHectares;
  final int quantidadeDeArvores;
  final String cep;
  final String cidade;
  final String estado;
  final GeoPoint localizacao;
  final String clonePredominante;
  final bool isSeringueiro;
  final bool isAgronomo;
  final bool isProprietario;
  final bool isAdmin;

  const NewPropertySubmit({
    required this.nomeDaPropriedade,
    required this.areaEmHectares,
    required this.quantidadeDeArvores,
    required this.cep,
    required this.cidade,
    required this.estado,
    required this.localizacao,
    required this.clonePredominante,
    required this.isSeringueiro,
    required this.isAgronomo,
    required this.isProprietario,
    required this.isAdmin,
  });

  @override
  List<Object> get props => [
        nomeDaPropriedade,
        areaEmHectares,
        quantidadeDeArvores,
        cep,
        cidade,
        estado,
        localizacao,
        clonePredominante,
        isSeringueiro,
        isAgronomo,
        isProprietario,
        isAdmin,
      ];
}
