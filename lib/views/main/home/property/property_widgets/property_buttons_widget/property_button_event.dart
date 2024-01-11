import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyButtonsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadPropertyButtons extends PropertyButtonsEvent {
  final User user;
  final String userId;
  final String propertyId;

  LoadPropertyButtons({
    required this.user,
    required this.userId,
    required this.propertyId,
  });

  @override
  List<Object> get props => [userId, propertyId];
}
