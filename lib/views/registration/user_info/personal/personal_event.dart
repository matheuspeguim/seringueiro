import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

abstract class PersonalEvent {}

class PersonalInfoSubmitted extends PersonalEvent {
  final User user;
  final XFile? imageFile;
  final String nome;
  final String idPersonalizado;
  final DateTime dataDeNascimento;
  final String cpf;
  final String rg;

  PersonalInfoSubmitted({
    required this.user,
    this.imageFile,
    required this.nome,
    required this.idPersonalizado,
    required this.dataDeNascimento,
    required this.cpf,
    required this.rg,
  });
}
