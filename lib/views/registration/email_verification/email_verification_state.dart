// email_verification_state.dart

import 'package:firebase_auth/firebase_auth.dart';

abstract class EmailVerificationState {}

class EmailVerificationInitial extends EmailVerificationState {}

class EmailVerificationLoading extends EmailVerificationState {}

class EmailVerificationSent extends EmailVerificationState {}

class EmailVerificationFailed extends EmailVerificationState {
  final String error;
  EmailVerificationFailed(this.error);
}

class EmailVerified extends EmailVerificationState {
  final User user;
  EmailVerified(this.user);
}
