// property_weather/property_weather_state.dart
import 'package:equatable/equatable.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';

abstract class PropertyWeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends PropertyWeatherState {}

class WeatherLoadInProgress extends PropertyWeatherState {}

class WeatherLoadSuccess extends PropertyWeatherState {
  final WeatherResponse weather;

  WeatherLoadSuccess({required this.weather});

  @override
  List<Object?> get props => [weather];
}

class WeatherLoadFailure extends PropertyWeatherState {
  final String error;

  WeatherLoadFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
