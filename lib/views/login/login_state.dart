// login_state.dart

import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class EmailNotVerified extends LoginState {
  final User user;
  EmailNotVerified({required this.user});
}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess({required this.user});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
