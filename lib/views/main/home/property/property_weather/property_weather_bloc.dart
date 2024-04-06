import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/services/weather_service.dart';
import 'property_weather_event.dart';
import 'property_weather_state.dart';

class PropertyWeatherBloc
    extends Bloc<PropertyWeatherEvent, PropertyWeatherState> {
  final WeatherService _weatherService;

  PropertyWeatherBloc({required WeatherService weatherService})
      : _weatherService = weatherService,
        super(WeatherInitial()) {
    on<LoadWeather>(_onLoadWeather);
  }

  Future<void> _onLoadWeather(
      LoadWeather event, Emitter<PropertyWeatherState> emit) async {
    emit(WeatherLoadInProgress());
    try {
      final weather = await _weatherService
          .fetchWeather(event.latitude, event.longitude, forceRefresh: true);
      if (weather != null) {
        emit(WeatherLoadSuccess(weather: weather));
      } else {
        emit(WeatherLoadFailure(
            error: "Não foi possível obter os dados do clima."));
      }
    } catch (e) {
      emit(WeatherLoadFailure(error: "Erro ao carregar dados do clima: $e"));
    }
  }
}
