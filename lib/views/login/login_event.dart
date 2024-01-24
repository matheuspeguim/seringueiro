// login_event.dart

abstract class LoginEvent {}

class LoginWithEmailSubmitted extends LoginEvent {
  final String email;
  final String senha;

  LoginWithEmailSubmitted({required this.email, required this.senha});
}

class LoginWithGoogleSubmitted extends LoginEvent {}
