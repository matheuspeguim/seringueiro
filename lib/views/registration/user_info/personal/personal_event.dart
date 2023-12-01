import 'package:firebase_auth/firebase_auth.dart';

abstract class PersonalEvent {}

class PersonalInfoSubmitted extends PersonalEvent {
  final User user;
  final String nome;
  final DateTime dataDeNascimento;
  final String cpf;
  final String rg;

  PersonalInfoSubmitted({
    required this.user,
    required this.nome,
    required this.dataDeNascimento,
    required this.cpf,
    required this.rg,
  });
}
