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
}
