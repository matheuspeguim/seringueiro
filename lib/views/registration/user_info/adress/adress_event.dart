import 'package:firebase_auth/firebase_auth.dart';

abstract class AdressEvent {}

class FetchAdressByCep extends AdressEvent {
  final String cep;

  FetchAdressByCep({required this.cep});
}

class AdressInfoSubmitted extends AdressEvent {
  final User user;
  final String cep;
  final String rua;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;

  AdressInfoSubmitted({
    required this.user,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
  });
}
