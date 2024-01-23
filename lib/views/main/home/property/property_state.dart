import 'package:equatable/equatable.dart';
import 'package:flutter_seringueiro/models/property.dart';

abstract class PropertyState extends Equatable {
  @override
  List<Object> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final Property property;

  PropertyLoaded(this.property);

  @override
  List<Object> get props => [property];
}

class PropertyError extends PropertyState {
  final String message;

  PropertyError(this.message);

  @override
  List<Object> get props => [message];
}

class PropertyDeleted extends PropertyState {}
