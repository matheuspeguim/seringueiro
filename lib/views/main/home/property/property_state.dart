import 'package:equatable/equatable.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

abstract class PropertyState extends Equatable {
  @override
  List<Object> get props => [];
  late final Property property;
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final Property property;
  PropertyLoaded(this.property);
  @override
  List<Object> get props => [property];
}

class PropertyDeleted extends PropertyState {}

class PropertyError extends PropertyState {
  final String message;
  PropertyError(this.message);
  @override
  List<Object> get props => [message];
}

class UserActivityFetched extends PropertyState {
  final String activity;
  UserActivityFetched({required this.activity});
  @override
  List<Object> get props => [activity];
}

class UserActivityFetchFailed extends PropertyState {}

// Estados para combinações de papéis

class SeringueiroViewState extends PropertyState {
  final Property property;
  SeringueiroViewState(this.property);

  @override
  List<Object> get props => [property];
}

class AgronomoViewState extends PropertyState {
  final Property property;
  AgronomoViewState(this.property);

  @override
  List<Object> get props => [property];
}

class ProprietarioViewState extends PropertyState {
  final Property property;
  ProprietarioViewState(this.property);

  @override
  List<Object> get props => [property];
}

class SeringueiroAgronomoViewState extends PropertyState {
  final Property property;
  SeringueiroAgronomoViewState(this.property);

  @override
  List<Object> get props => [property];
}

class SeringueiroProprietarioViewState extends PropertyState {
  final Property property;
  SeringueiroProprietarioViewState(this.property);

  @override
  List<Object> get props => [property];
}

class AgronomoProprietarioViewState extends PropertyState {
  final Property property;
  AgronomoProprietarioViewState(this.property);

  @override
  List<Object> get props => [property];
}

class TodosViewState extends PropertyState {
  final Property property;
  TodosViewState(this.property);

  @override
  List<Object> get props => [property];
}

// Com admin

class AdminViewState extends PropertyState {
  final Property property;
  AdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class SeringueiroAdminViewState extends PropertyState {
  final Property property;
  SeringueiroAdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class AgronomoAdminViewState extends PropertyState {
  final Property property;
  AgronomoAdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class ProprietarioAdminViewState extends PropertyState {
  final Property property;
  ProprietarioAdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class SeringueiroAgronomoAdminViewState extends PropertyState {
  final Property property;
  SeringueiroAgronomoAdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class SeringueiroProprietarioAdminViewState extends PropertyState {
  final Property property;
  SeringueiroProprietarioAdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class AgronomoProprietarioAdminViewState extends PropertyState {
  final Property property;
  AgronomoProprietarioAdminViewState(this.property);

  @override
  List<Object> get props => [property];
}

class TodosViewStateAdmin extends PropertyState {
  final Property property;
  TodosViewStateAdmin(this.property);

  @override
  List<Object> get props => [property];
}
