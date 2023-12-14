import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherApiService weatherApiService;
  DateTime? lastUpdate;

  WeatherBloc({required this.weatherApiService}) : super(WeatherInitial()) {
    on<WeatherRequested>(_onWeatherRequested);
  }

  Future<void> _onWeatherRequested(
      WeatherRequested event, Emitter<WeatherState> emit) async {
    // Verifica se a última atualização foi há menos de uma hora
    if (lastUpdate != null &&
        DateTime.now().difference(lastUpdate!).inHours < 1) {
      // Se sim, emite o último estado de sucesso, se disponível
      final currentState = state;
      if (currentState is WeatherLoadSuccess) {
        emit(currentState);
        return;
      }
    }

    emit(WeatherLoadInProgress());
    try {
      final weatherData =
          await weatherApiService.fetchWeather(event.latitude, event.longitude);
      lastUpdate = DateTime.now(); // Atualiza a hora da última atualização
      emit(WeatherLoadSuccess(weatherData));
    } catch (error) {
      emit(WeatherLoadFailure(error.toString()));
    }
  }
}
