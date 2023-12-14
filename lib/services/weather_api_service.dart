import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  final String apiKey;

  WeatherApiService({required this.apiKey});

  Future<Map<String, dynamic>> fetchWeather(
      double latitude, double longitude) async {
    final url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&exclude=minutely&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Falha ao buscar dados da API de clima");
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather(
      double latitude, double longitude) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'temperatura': data['main']['temp'],
        'precipitacao': data['rain'] != null ? data['rain']['1h'] : 0,
        'umidade': data['main']['humidity']
      };
    } else {
      throw Exception('Erro ao buscar dados do clima');
    }
  }
}
