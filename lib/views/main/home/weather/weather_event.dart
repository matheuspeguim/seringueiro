import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class WeatherRequested extends WeatherEvent {
  final double latitude;
  final double longitude;

  const WeatherRequested(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}
