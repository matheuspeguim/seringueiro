import 'package:image_picker/image_picker.dart';

abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String senha;
  final String celular;
  final String idPersonalizado;
  final String nome;
  final String nascimento;
  final String cpf;
  final String rg;
  final String cep;
  final String logradouro;
  final String numero;
  final String bairro;
  final String cidade;
  final String estado;
  final XFile? imageFile;

  SignUpSubmitted({
    required this.email,
    required this.senha,
    required this.celular,
    required this.idPersonalizado,
    required this.nome,
    required this.nascimento,
    required this.cpf,
    required this.rg,
    required this.cep,
    required this.logradouro,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.imageFile,
  });
}

class EmailVerificationSent extends SignUpEvent {}

class CheckEmailVerification extends SignUpEvent {}

class CheckEmailVerified extends SignUpEvent {}
