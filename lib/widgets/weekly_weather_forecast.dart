import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WeeklyWeatherForecast extends StatefulWidget {
  @override
  _WeeklyWeatherForecastState createState() => _WeeklyWeatherForecastState();
}

class _WeeklyWeatherForecastState extends State<WeeklyWeatherForecast> {
  late Future<Map<String, dynamic>> weatherData;
  final weatherApi =
      WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);

  @override
  void initState() {
    super.initState();
    print("OPENWEATHER_API_KEY: ${dotenv.env['OPENWEATHER_API_KEY']}");
    weatherData = weatherApi.fetchWeeklyWeather();
  }

  double convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double paddingValue = width > 600 ? 48.0 : 16.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: paddingValue),
      child: FutureBuilder<Map<String, dynamic>>(
        future: weatherData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erro: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return Text('Sem dados disponíveis');
          } else {
            List dailyForecast = snapshot.data!['daily'];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                var dayData = dailyForecast[index];
                var iconCode = dayData['weather'][0]['icon'];
                var minTemp = convertKelvinToCelsius(dayData['temp']['min'])
                    .toStringAsFixed(1);
                var maxTemp = convertKelvinToCelsius(dayData['temp']['max'])
                    .toStringAsFixed(1);

                return Column(
                  children: [
                    // Substitua a URL do ícone se você tiver seus próprios ícones
                    Image.network(
                      'http://openweathermap.org/img/wn/$iconCode.png',
                      width: 25,
                    ),
                    Text("$minTemp \n$maxTemp°C"),
                  ],
                );
              }),
            );
          }
        },
      ),
    );
  }
}
