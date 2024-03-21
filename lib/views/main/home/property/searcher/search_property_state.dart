import 'package:flutter_seringueiro/common/models/property.dart';

abstract class SearchPropertyState {}

class SearchInitial extends SearchPropertyState {}

class SearchInProgress extends SearchPropertyState {}

class SearchSuccess extends SearchPropertyState {
  final List<Property> properties;

  SearchSuccess(this.properties);
}

class SearchFailure extends SearchPropertyState {
  final String error;

  SearchFailure(this.error);
}
