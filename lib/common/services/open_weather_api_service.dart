import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OpenWeatherApiService {
  final String apiKey;
  late Box _cacheBox;
  bool _isCacheInitialized = false;

  OpenWeatherApiService({required this.apiKey}) {
    _initCache();
  }

  Future<void> _initCache() async {
    _cacheBox = await Hive.openBox('weatherCache');
    _isCacheInitialized = true;
  }

  void _cleanUpCache() async {
    if (!_isCacheInitialized) await _initCache();

    final cacheDuration = Duration(hours: 1);
    var keysToRemove = [];

    _cacheBox.toMap().forEach((key, value) {
      var fetchTime = DateTime.parse(value['fetchTime']);
      if (DateTime.now().difference(fetchTime) > cacheDuration) {
        keysToRemove.add(key);
      }
    });

    for (var key in keysToRemove) {
      _cacheBox.delete(key);
    }
  }

  Future<Map<String, dynamic>> _fetchWeather(
      double latitude, double longitude) async {
    final url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&exclude=minutely&appid=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro na API: ${response.statusCode} - ${response.body}');
        throw Exception("Falha ao buscar dados da API de clima");
      }
    } catch (e) {
      print('Erro ao fazer a chamada da API: $e');
      rethrow; // Relançar a exceção capturada
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather(
      double latitude, double longitude) async {
    _cleanUpCache();
    final cacheKey = '$latitude,$longitude';

    var cachedData = await _getCachedWeather(cacheKey);
    if (cachedData != null) return cachedData;

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception("Sem conexão com a internet");
    }

    var fetchedData = await _fetchWeather(latitude, longitude);
    await _updateCache(cacheKey, fetchedData);
    return fetchedData;
  }

  Future<void> _updateCache(String cacheKey, Map<String, dynamic> data) async {
    if (_isCacheInitialized) {
      DateTime now = DateTime.now();
      await _cacheBox.put(cacheKey, {
        'data': data,
        'fetchTime': now.toIso8601String(),
        'apiRequestTime': now.toIso8601String()
      });
    }
  }

  Future<Map<String, dynamic>?> _getCachedWeather(String cacheKey) async {
    if (_isCacheInitialized && _cacheBox.containsKey(cacheKey)) {
      var cachedData = _cacheBox.get(cacheKey);
      var fetchTime = DateTime.parse(cachedData['fetchTime']);
      var apiRequestTime = DateTime.parse(cachedData['apiRequestTime']);

      if (DateTime.now().difference(fetchTime) < Duration(hours: 1)) {
        print("Dados da API obtidos em: $apiRequestTime");
        return cachedData['data'];
      }
    }
    return null;
  }

  Future<Map<String, dynamic>> weatherToFieldActivity(
      double latitude, double longitude) async {
    _cleanUpCache();

    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Processando e retornando apenas os dados relevantes
        return {
          'temperature': data['main']['temp'],
          'humidity': data['main']['humidity'],
          'condition': data['weather'][0]['main'],
          'icon': data['weather'][0]['icon'],
          // Inclua outros campos relevantes conforme necessário
        };
      } else {
        print('Erro na API: ${response.statusCode} - ${response.body}');
        throw Exception("Falha ao buscar dados da API de clima");
      }
    } catch (e) {
      print('Erro ao fazer a chamada da API: $e');
      rethrow; // Relançar a exceção capturada
    }
  }

  Future<Map<String, dynamic>> fetchRainHistory(double latitude,
      double longitude, int startTimestamp, int endTimestamp) async {
    _cleanUpCache();

    final url = Uri.parse(
        "https://history.openweathermap.org/data/2.5/history/city?lat=$latitude&lon=$longitude&type=hour&start=$startTimestamp&end=$endTimestamp&appid=$apiKey");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Erro na API: ${response.statusCode} - ${response.body}');
        throw Exception("Falha ao buscar dados históricos de chuva");
      }
    } catch (e) {
      print('Erro ao fazer a chamada da API: $e');
      rethrow;
    }
  }
}
