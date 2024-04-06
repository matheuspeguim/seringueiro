// property_weather/property_weather_event.dart
import 'package:equatable/equatable.dart';

abstract class PropertyWeatherEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadWeather extends PropertyWeatherEvent {
  final double latitude;
  final double longitude;

  LoadWeather({required this.latitude, required this.longitude});

  @override
  List<Object?> get props => [latitude, longitude];
}
