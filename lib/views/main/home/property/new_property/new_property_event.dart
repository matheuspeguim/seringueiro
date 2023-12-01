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
  final int quantidadeDeArvores;
  final String? atividadeSelecionada;
  final LatLng localizacao;

  SubmitPropertyData({
    required this.user,
    required this.nomeDaPropriedade,
    required this.quantidadeDeArvores,
    required this.atividadeSelecionada,
    required this.localizacao,
  });
}
