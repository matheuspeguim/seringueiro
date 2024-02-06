import 'package:firebase_auth/firebase_auth.dart';

abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class EmailVerificationSentState extends SignUpState {}

class EmailVerificationInProgress extends SignUpState {}

class EmailVerificationDone extends SignUpState {}

class SignUpFailure extends SignUpState {
  final String error;

  SignUpFailure(this.error);
}

class SignUpSuccess extends SignUpState {
  final User user;

  SignUpSuccess({required this.user});
}
