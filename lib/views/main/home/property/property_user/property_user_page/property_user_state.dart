import 'package:flutter_seringueiro/common/models/property_user.dart';

abstract class PropertyUserState {}

class PropertyUserInitial extends PropertyUserState {}

class PropertyUserLoading extends PropertyUserState {}

class PropertyUserLoaded extends PropertyUserState {
  final PropertyUser propertyUser;
  final bool isAdmin; // Indica se o usuário atual é administrador
  final bool
      isTargetUserSeringueiro; // Indica se o usuário do perfil é um seringueiro

  PropertyUserLoaded({
    required this.propertyUser,
    this.isAdmin = false,
    this.isTargetUserSeringueiro = false,
  });
}

class PropertyUserRolesUpdated extends PropertyUserState {
  final PropertyUser propertyUser;

  PropertyUserRolesUpdated(this.propertyUser);
}

class PropertyUserConfirmed extends PropertyUserState {}

class PropertyUserDeleted extends PropertyUserState {}

class PropertyUserError extends PropertyUserState {
  final String message;

  PropertyUserError(this.message);
}
