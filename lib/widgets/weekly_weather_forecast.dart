import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_icons/weather_icons.dart';

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
    weatherData = weatherApi.fetchWeeklyWeather();
  }

  double convertKelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }

  IconData mapWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.day_sunny;
      case '01n':
        return WeatherIcons.night_clear;
      case '02d':
        return WeatherIcons.day_cloudy;
      case '02n':
        return WeatherIcons.night_cloudy;
      case '03d':
      case '03n':
        return WeatherIcons.cloud;
      case '04d':
      case '04n':
        return WeatherIcons.cloudy; // Clouds Broken
      case '09d':
      case '09n':
        return WeatherIcons.rain;
      case '10d':
        return WeatherIcons.day_rain;
      case '10n':
        return WeatherIcons.night_rain;
      case '11d':
      case '11n':
        return WeatherIcons.thunderstorm;
      case '13d':
      case '13n':
        return WeatherIcons.snow;
      case '50d':
      case '50n':
        return WeatherIcons.fog;
      default:
        return WeatherIcons.alien; // Default para ícones desconhecidos
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(7, (index) {
              var dayData = dailyForecast[index];
              var iconCode = dayData['weather'][0]['icon'];
              var minTemp = convertKelvinToCelsius(dayData['temp']['min'])
                  .toStringAsFixed(1);
              var maxTemp = convertKelvinToCelsius(dayData['temp']['max'])
                  .toStringAsFixed(1);

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(
                        8.0), // Adiciona um padding em todos os lados
                    child: Column(
                      children: [
                        Icon(
                          mapWeatherIcon(iconCode),
                          size: 25,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  8.0), // Adiciona um padding apenas na parte de baixo
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        }
      },
    );
  }
}
