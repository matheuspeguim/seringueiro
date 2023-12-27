import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class WeatherApiService {
  final String apiKey;
  late Box _cacheBox;
  bool _isCacheInitialized = false;

  WeatherApiService({required this.apiKey}) {
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
    var connectivityResult = await Connectivity().checkConnectivity();

    if (_isCacheInitialized && _cacheBox.containsKey(cacheKey)) {
      var cachedData = _cacheBox.get(cacheKey);
      var fetchTime = DateTime.parse(cachedData['fetchTime']);

      if (DateTime.now().difference(fetchTime) < Duration(hours: 1) ||
          connectivityResult == ConnectivityResult.none) {
        return cachedData['data'];
      }
    }

    if (connectivityResult != ConnectivityResult.none) {
      var fetchedData = await _fetchWeather(latitude, longitude);
      if (_isCacheInitialized) {
        await _cacheBox.put(cacheKey, {
          'data': fetchedData,
          'fetchTime': DateTime.now().toIso8601String()
        });
      }
      return fetchedData;
    } else {
      throw Exception("Sem conexão com a internet");
    }
  }
}
