// user_search_state.dart
import 'package:flutter_seringueiro/common/models/usuario.dart';

abstract class UserSearchState {}

class UserSearchInitial extends UserSearchState {}

class UserSearchLoading extends UserSearchState {}

class UserSearchEmpty extends UserSearchState {}

class UserSearchSuccess extends UserSearchState {
  final List<Usuario> users;

  UserSearchSuccess(this.users);
}

class UserSearchError extends UserSearchState {
  final String message;

  UserSearchError(this.message);
}

class UserSelectedState extends UserSearchState {
  final Usuario user;

  UserSelectedState(this.user);
}

class PropertySelectionNeeded extends UserSearchState {
  final Usuario user;

  PropertySelectionNeeded(this.user);
}
