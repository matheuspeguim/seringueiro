// signup_event.dart
abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String celular;
  final String senha;
  final String confirmarSenha;

  SignUpSubmitted(this.email, this.celular, this.senha, this.confirmarSenha);
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;

  SignUpEmailChanged(this.email);
}

// Adicione mais eventos conforme necessário...
