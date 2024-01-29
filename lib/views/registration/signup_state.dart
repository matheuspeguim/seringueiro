abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpEmailVerificationSent extends SignUpState {}

class SignUpUserAlreadyExists extends SignUpState {}

class SignUpEmailVerificationTimeout extends SignUpState {}

class SignUpEmailVerified extends SignUpState {}

class SignUpPersonalInfoSubmitted extends SignUpState {}

class SignUpPersonalInfoSaved extends SignUpState {}

class SignUpCelularSubmitted extends SignUpState {}

class SignUpCelularVerified extends SignUpState {}

class EnderecoInfoState extends SignUpState {
  final bool isEnderecoInfoValid;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;
  final String cep;

  EnderecoInfoState({
    required this.isEnderecoInfoValid,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    required this.cep,
  });
}

class EnderecoFailure extends SignUpState {
  final String error;
  EnderecoFailure({required this.error});
}

class SignUpEnderecoInfoSubmitted extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);
}

class SignUpSuccess extends SignUpState {}
