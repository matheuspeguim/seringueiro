// registration_state.dart

abstract class RegistrationState {}

class RegistrationInitialState extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationFailure extends RegistrationState {
  final String error;

  RegistrationFailure({required this.error});
}

class RegistrationPersonalInfoState extends RegistrationState {
  final bool isPersonalInfoValid;

  RegistrationPersonalInfoState({required this.isPersonalInfoValid});
}

class RegistrationPersonalInfoSuccess extends RegistrationState {}

class RegistrationContactInfoState extends RegistrationState {
  final bool isContactInfoValid;

  RegistrationContactInfoState({required this.isContactInfoValid});
}

class RegistrationAdressInfoState extends RegistrationState {
  final bool isAdressInfoValid;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;

  RegistrationAdressInfoState({
    required this.isAdressInfoValid,
    this.rua = '',
    this.bairro = '',
    this.cidade = '',
    this.estado = '',
  });
}

class RegistrationAdressInfoSuccess extends RegistrationState {}
