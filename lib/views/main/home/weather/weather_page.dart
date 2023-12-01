import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_event.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de dados para a previsão horária
class HourlyWeatherForecast {
  final DateTime time;
  final String weatherIcon;
  final double temperature;

  HourlyWeatherForecast({
    required this.time,
    required this.weatherIcon,
    required this.temperature,
  });
}

// Função para analisar os dados da API e obter a previsão horária
List<HourlyWeatherForecast> parseWeatherData(Map<String, dynamic> weatherData) {
  var hourlyForecasts = weatherData['hourly'] as List;
  return hourlyForecasts
      .map((hourlyData) {
        final time =
            DateTime.fromMillisecondsSinceEpoch(hourlyData['dt'] * 1000);
        final weatherIcon = hourlyData['weather'][0]['icon'];
        // Convertendo a temperatura
        final temperature = hourlyData['temp'].toDouble() - 273.15;
        return HourlyWeatherForecast(
          time: time,
          weatherIcon: weatherIcon,
          temperature: temperature,
        );
      })
      .take(24)
      .toList(); // Pega as próximas 24 horas
}

// Widget para mostrar um cartão de previsão individual horária
class HourlyForecastCard extends StatelessWidget {
  final HourlyWeatherForecast forecast;

  bool isCurrentHour(DateTime forecastTime) {
    DateTime now = DateTime.now();
    DateTime currentHour = DateTime(now.year, now.month, now.day, now.hour);
    return currentHour ==
        DateTime(forecastTime.year, forecastTime.month, forecastTime.day,
            forecastTime.hour);
  }

  HourlyForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String displayTime = isCurrentHour(forecast.time)
        ? 'Agora'
        : DateFormat('HH:mm').format(forecast.time);

    return Container(
      width: 80,
      child: Column(
        children: [
          Text(
            displayTime,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Image.network(
            'http://openweathermap.org/img/wn/${forecast.weatherIcon}.png',
            width: 50,
            height: 50,
          ),
          Text('${forecast.temperature.toStringAsFixed(1)}°'),
        ],
      ),
    );
  }
}

// Widget para mostrar a linha de previsões do tempo horárias
class HourlyWeatherRow extends StatelessWidget {
  final List<HourlyWeatherForecast> forecastList;

  HourlyWeatherRow({Key? key, required this.forecastList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: forecastList
            .map((forecast) => HourlyForecastCard(forecast: forecast))
            .toList(),
      ),
    );
  }
}

// Widget principal que usa o WeatherBloc para buscar e exibir a previsão do tempo por hora
class WeatherWidget extends StatelessWidget {
  final GeoPoint location;

  WeatherWidget({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double latitude = location.latitude;
    final double longitude = location.longitude;

    return BlocProvider<WeatherBloc>(
      create: (context) => WeatherBloc(
          weatherApiService:
              WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!))
        ..add(WeatherRequested(latitude, longitude)),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoadSuccess) {
            final forecastList = parseWeatherData(state.weatherData);
            return HourlyWeatherRow(forecastList: forecastList);
          } else if (state is WeatherLoadFailure) {
            return Text('Falha ao carregar dados do clima');
          } else {
            return Container(); // Estado inicial ou desconhecido
          }
        },
      ),
    );
  }
}
