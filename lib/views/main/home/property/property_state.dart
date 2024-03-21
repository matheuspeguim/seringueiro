import 'package:equatable/equatable.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';

abstract class PropertyState extends Equatable {
  @override
  List<Object> get props => [];
}

class PropertyInitial extends PropertyState {}

class PropertyLoading extends PropertyState {}

class PropertyLoaded extends PropertyState {
  final Property property;
  final PropertyUser propertyUser;

  PropertyLoaded(this.property, this.propertyUser);

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
