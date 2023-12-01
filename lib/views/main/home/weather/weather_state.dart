import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoadInProgress extends WeatherState {}

class WeatherLoadSuccess extends WeatherState {
  final Map<String, dynamic> weatherData;

  const WeatherLoadSuccess(this.weatherData);

  @override
  List<Object> get props => [weatherData];
}

class WeatherLoadFailure extends WeatherState {
  final String error;

  const WeatherLoadFailure(this.error);

  @override
  List<Object> get props => [error];
}
