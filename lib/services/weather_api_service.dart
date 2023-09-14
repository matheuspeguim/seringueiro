import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherApiService {
  final String apiKey;

  WeatherApiService({required this.apiKey});

  Future<Map<String, dynamic>> fetchWeeklyWeather() async {
    // Latitude e Longitude de Poloni, SP
    final double lat = -20.7828;
    final double lon = -49.8258;

    final url =
        "https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=hourly,minutely&appid=$apiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Falha ao buscar dados da API de clima");
    }
  }
}
