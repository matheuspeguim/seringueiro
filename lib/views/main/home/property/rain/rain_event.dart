import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

abstract class RainEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class StartRainRecording extends RainEvent {}

class SaveRainRecord extends RainEvent {
  final User user;
  final Property property;
  final DateTime date;
  final int rainAmount;

  SaveRainRecord({
    required this.user,
    required this.property,
    required this.date,
    required this.rainAmount,
  });

  @override
  List<Object?> get props => [user, property, date, rainAmount];
}

class LoadRainData extends RainEvent {
  final String propertyId;

  LoadRainData({required this.propertyId});

  @override
  List<Object?> get props => [propertyId];
}
