import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiService weatherApiService;

  WeatherBloc({required this.weatherApiService}) : super(WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested);
  }

  Future<void> _onWeatherRequested(
      WeatherRequested event, Emitter<WeatherState> emit) async {
    emit(WeatherLoadInProgress());
    try {
      final weatherData =
          await weatherApiService.fetchWeather(event.latitude, event.longitude);
      emit(WeatherLoadSuccess(weatherData));
    } catch (error) {
      emit(WeatherLoadFailure(error.toString()));
    }
  }
}
