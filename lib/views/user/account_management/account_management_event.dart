import 'package:image_picker/image_picker.dart';

abstract class AccountManagementEvent {}

class ProfileImageSubmitted extends AccountManagementEvent {
  final XFile imageFile;
  ProfileImageSubmitted({required this.imageFile});
}

class PersonalDataSubmitted extends AccountManagementEvent {
  final String? idPersonalizado;
  final String? nome;
  final String? nascimento;
  final String? cpf;
  final String? rg;

  PersonalDataSubmitted(
    this.idPersonalizado,
    this.nome,
    this.nascimento,
    this.cpf,
    this.rg,
  );
}

class ContactDataSubmitted extends AccountManagementEvent {
  final String celular;
  ContactDataSubmitted({required this.celular});
}

class AdressDataSubmitted extends AccountManagementEvent {
  final String? cep;
  final String? logradouro;
  final String? numero;
  final String? bairro;
  final String? cidade;
  final String? estado;

  AdressDataSubmitted(
    this.cep,
    this.logradouro,
    this.numero,
    this.bairro,
    this.cidade,
    this.estado,
  );
}
