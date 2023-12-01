import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class PropertyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

//PROPERTY EVENTS

class LoadPropertyDetails extends PropertyEvent {
  final User user;
  final String propertyId;

  LoadPropertyDetails(this.user, this.propertyId);

  @override
  List<Object> get props => [propertyId];
}

class DeleteProperty extends PropertyEvent {
  final User user;
  final String propertyId;

  DeleteProperty(this.user, this.propertyId);

  @override
  List<Object> get props => [propertyId];
}

class FetchUserActivity extends PropertyEvent {
  final String userId;
  final String propertyId;

  FetchUserActivity({required this.userId, required this.propertyId});
}

//SANGRIA EVENTS

class StartSangria extends PropertyEvent {}
