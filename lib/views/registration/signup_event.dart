abstract class SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {
  final String email;
  final String senha;

  SignUpSubmitted({required this.email, required this.senha});
}

class EmailVerificationSent extends SignUpEvent {}

class CheckEmailVerification extends SignUpEvent {}
