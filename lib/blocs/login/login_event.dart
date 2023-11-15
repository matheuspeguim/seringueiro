// login_event.dart

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String email;
  final String senha;

  LoginSubmitted({required this.email, required this.senha});
}
