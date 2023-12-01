abstract class AdressState {}

class AdressInitial extends AdressState {}

class AdressLoading extends AdressState {}

class AdressInfoState extends AdressState {
  final bool isAdressInfoValid;
  final String rua;
  final String bairro;
  final String cidade;
  final String estado;
  final String? message; // Para mensagens de sucesso ou erro

  AdressInfoState({
    required this.isAdressInfoValid,
    required this.rua,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.message,
  });
}

class AdressInfoSuccess extends AdressState {
  final String message;

  AdressInfoSuccess({required this.message});
}

class AdressFailure extends AdressState {
  final String error;

  AdressFailure({required this.error});
}
