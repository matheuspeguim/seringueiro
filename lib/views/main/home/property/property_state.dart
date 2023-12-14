import 'package:equatable/equatable.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

abstract class PropertyState extends Equatable {
  @override
  List<Object> get props => [];

  get property => null;
}

//PROPERTY STATE
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

class UserActivityFetchFailed extends PropertyState {
  @override
  List<Object> get props => [];
}

//SANGRIA STATE

class SangriaInProgress extends PropertyState {
  final Duration duration;
  SangriaInProgress(this.duration);
}
