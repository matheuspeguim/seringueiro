import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class NewPropertyEvent {}

class StartLocationSelection extends NewPropertyEvent {}

class ConfirmLocation extends NewPropertyEvent {
  final LatLng location;
  ConfirmLocation(this.location);
}

class EnterPropertyName extends NewPropertyEvent {}

class SubmitPropertyData extends NewPropertyEvent {
  final User user;
  final String nomeDaPropriedade;
  final int areaEmHectares;
  final int quantidadeDeArvores;
  final Map<String, bool> atividadesSelecionadas; // Tipo atualizado para Map
  final LatLng localizacao;

  SubmitPropertyData({
    required this.user,
    required this.nomeDaPropriedade,
    required this.areaEmHectares,
    required this.quantidadeDeArvores,
    required this.atividadesSelecionadas, // Parâmetro atualizado
    required this.localizacao,
  });
}
