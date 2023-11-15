// registration_event.dart

import 'package:firebase_auth/firebase_auth.dart';

abstract class RegistrationEvent {}

//Personal info
class RegistrationPersonalInfoSubmitted extends RegistrationEvent {
  final User user;
  final String nome;
  final String cpf;
  final String rg;
  final DateTime dataDeNascimento;

  RegistrationPersonalInfoSubmitted({
    required this.user,
    required this.nome,
    required this.cpf,
    required this.rg,
    required this.dataDeNascimento,
  });
}

//Contact info
class RegistrationContactInfoSubmitted extends RegistrationEvent {
  final String email;
  final String celular;

  RegistrationContactInfoSubmitted({
    required this.email,
    required this.celular,
  });
}

//Adress info
class RegistrationAdressInfoSubmitted extends RegistrationEvent {
  final User user;
  final String cep;
  final String numero;
  final String rua;
  final String bairro;
  final String estado;
  final String cidade;

  RegistrationAdressInfoSubmitted({
    required this.user,
    required this.cep,
    required this.numero,
    required this.rua,
    required this.bairro,
    required this.estado,
    required this.cidade,
  });
}

class FetchAdressByCep extends RegistrationEvent {
  final String cep;

  FetchAdressByCep({required this.cep});
}
