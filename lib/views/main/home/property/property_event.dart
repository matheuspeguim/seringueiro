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
  final User user;
  final String propertyId;

  DeleteProperty(this.user, this.propertyId);

  @override
  List<Object> get props => [user, propertyId];
}

// Novo evento para buscar o papel do usuário na propriedade
class GetPropertyUserRole extends PropertyEvent {
  final String userId;
  final String propertyId;

  GetPropertyUserRole({required this.userId, required this.propertyId});

  @override
  List<Object> get props => [userId, propertyId];
}
