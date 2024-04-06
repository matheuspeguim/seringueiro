import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';

class WeatherService {
  final String _baseUrl = "https://api.openweathermap.org/data/3.0/onecall";
  Box<WeatherResponse>? _weatherBox;

  WeatherService() {
    _initialize();
  }

  Future<void> _initialize() async {
    // Certifique-se de que o Hive está inicializado e os adaptadores registrados antes desta chamada
    _weatherBox = await Hive.openBox<WeatherResponse>('weatherData');
    await _cleanOldCache(); // Limpa dados antigos no cache ao inicializar
  }

  Future<void> _cleanOldCache() async {
    final currentTime =
        DateTime.now().millisecondsSinceEpoch ~/ 1000; // Converte para segundos
    final oneDaySeconds = 24 * 60 * 60; // 1 dia em segundos

    final keysToRemove = _weatherBox!.keys.where((key) {
      final cachedItem = _weatherBox!.get(key);
      return cachedItem != null &&
          (currentTime - cachedItem.timestamp) > oneDaySeconds;
    }).toList();

    for (var key in keysToRemove) {
      await _weatherBox!.delete(key);
    }
  }

  Future<WeatherResponse?> fetchWeather(double lat, double lon,
      {bool forceRefresh = false}) async {
    final String coordinatesKey = "${lat.toString()}_${lon.toString()}";
    final cachedWeather = await getCachedWeather(coordinatesKey);

    // Definindo limites de tempo em segundos
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (cachedWeather != null && !forceRefresh) {
      // Se os dados forem recentes (menos de 2 horas), usa o cache
      if ((currentTime - cachedWeather.timestamp) < 2 * 60 * 60) {
        print('Recuperando weather do cache');
        return cachedWeather;
      }
    }

    // Tenta buscar novos dados se não houver cache válido ou se o cache estiver forçado a atualizar
    return await _tryToUpdateWeather(lat, lon, coordinatesKey);
  }

  Future<WeatherResponse?> _tryToUpdateWeather(
      double lat, double lon, String coordinatesKey) async {
    print('Buscando novos dados na API');
    final apiKey = dotenv.env['OPENWEATHER_API_KEY']!;
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'lat': lat.toString(),
      'lon': lon.toString(),
      'appid': apiKey,
      'units': 'metric',
      'lang': 'pt_br',
    });

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final weatherResponse =
            WeatherResponse.fromJson(json.decode(response.body));
        // Atualiza o timestamp para o momento atual em segundos
        weatherResponse.timestamp =
            DateTime.now().millisecondsSinceEpoch ~/ 1000;
        await _weatherBox?.put(coordinatesKey, weatherResponse);
        return weatherResponse;
      }
    } catch (e) {
      print('Erro ao conectar com a API: $e');
    }
    return null; // Retorna null se a atualização falhar
  }

  Future<WeatherResponse?> getCachedWeather(String coordinatesKey) async {
    return _weatherBox?.get(coordinatesKey);
  }
}
