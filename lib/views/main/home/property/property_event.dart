import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PropertyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPropertyDetails extends PropertyEvent {
  final User user;
  final String propertyId;

  LoadPropertyDetails(this.user, this.propertyId);

  @override
  List<Object> get props => [user, propertyId];
}

class DeleteProperty extends PropertyEvent {
  final String propertyId;

  DeleteProperty(this.propertyId);

  @override
  List<Object> get props => [propertyId];
}
