// login_state.dart

import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class PersonalInfoMissing extends LoginState {
  final User user;
  PersonalInfoMissing({required this.user});
}

class AdressInfoMissing extends LoginState {
  final User user;
  AdressInfoMissing({required this.user});
}

class LoginSuccess extends LoginState {
  final User user;

  LoginSuccess({required this.user});
}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}
