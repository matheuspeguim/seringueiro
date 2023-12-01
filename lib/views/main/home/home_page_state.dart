// home_page_state.dart

import 'package:flutter_seringueiro/views/main/home/property/property.dart';

abstract class HomePageState {}

class HomePageInitial extends HomePageState {}

class UserDataLoading extends HomePageState {}

class UserDataLoaded extends HomePageState {
  final String firstName;
  UserDataLoaded(this.firstName);
}

class UserDataError extends HomePageState {
  final String message;
  UserDataError(this.message);
}

class PropertiesLoading extends HomePageState {}

class PropertiesLoaded extends HomePageState {
  final List<Property> properties;
  PropertiesLoaded(this.properties);
}

class PropertiesError extends HomePageState {
  final String message;
  PropertiesError(this.message);
}
