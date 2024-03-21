import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class NewPropertyState {}

class LocationSelectionState extends NewPropertyState {}

class LocationSelectedState extends NewPropertyState {
  final LatLng location;
  LocationSelectedState(this.location);
}

class PropertyNameEntryState extends NewPropertyState {
  final LatLng location;
  PropertyNameEntryState(this.location);
}

class NearbyPropertiesCheckedState extends NewPropertyState {
  final List<Property> nearbyProperties;
  NearbyPropertiesCheckedState(this.nearbyProperties);
}

class PropertySubmissionInProgress extends NewPropertyState {}

class PropertyCreationSuccessState extends NewPropertyState {
  final User user;
  PropertyCreationSuccessState(this.user);
}

class PropertyCreationFailedState extends NewPropertyState {
  final String error;
  PropertyCreationFailedState(this.error);
}

class PropertySubmissionSuccess extends NewPropertyState {}

class PropertySubmissionFailed extends NewPropertyState {
  final String error;
  PropertySubmissionFailed({required this.error});
}
