import 'package:firebase_auth/firebase_auth.dart';

abstract class AccountManagementState {}

class AccountManagementInitial extends AccountManagementState {}

class AccountManagementLoading extends AccountManagementState {}

class AccountManagementLoaded extends AccountManagementState {}

class AccountManagementFailure extends AccountManagementState {
  final String error;

  AccountManagementFailure(this.error);
}

class AccountManagementSuccess extends AccountManagementState {
  final User user;

  AccountManagementSuccess({required this.user});
}
