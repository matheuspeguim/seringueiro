import 'package:flutter_seringueiro/models/usuario.dart';

abstract class PropertyUsersState {}

class PropertyUsersInitial extends PropertyUsersState {}

class PropertyUsersLoading extends PropertyUsersState {}

class PropertyUsersLoaded extends PropertyUsersState {
  final List<Usuario> users;

  PropertyUsersLoaded(this.users);
}

class PropertyUsersError extends PropertyUsersState {
  final String message;

  PropertyUsersError(this.message);
}
