// Modelo de dados para a previsão diária
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_event.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_state.dart';
import 'package:flutter_seringueiro/widgets/custom_Circular_Progress_indicator.dart';
import 'package:intl/intl.dart';

class DailyWeatherForecast {
  final DateTime date;
  final String weatherIcon;
  final double rain;

  DailyWeatherForecast({
    required this.date,
    required this.weatherIcon,
    required this.rain,
  });
}

// Função para analisar os dados da API e obter a previsão diária
List<DailyWeatherForecast> parseDailyWeatherData(
    Map<String, dynamic> weatherData) {
  var dailyForecasts = weatherData['daily'] as List? ?? [];
  return dailyForecasts.map((dailyData) {
    final date = DateTime.fromMillisecondsSinceEpoch(dailyData['dt'] * 1000);
    final weatherIcon = dailyData['weather'][0]['icon'];
    final rain = dailyData['rain']?.toDouble() ?? 0.0;

    return DailyWeatherForecast(
      date: date,
      weatherIcon: weatherIcon,
      rain: rain,
    );
  }).toList();
}

class DailyForecastCard extends StatelessWidget {
  final DailyWeatherForecast forecast;

  DailyForecastCard({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String displayDate = DateFormat('EEE').format(forecast.date);
    if (now.day == forecast.date.day &&
        now.month == forecast.date.month &&
        now.year == forecast.date.year) {
      displayDate = "Hoje";
    }

    if (now.day + 1 == forecast.date.day &&
        now.month == forecast.date.month &&
        now.year == forecast.date.year) {
      displayDate = "Hoje";
    }

    return Container(
      width: 75,
      child: Column(
        children: [
          Text(
            displayDate,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  'http://openweathermap.org/img/wn/${forecast.weatherIcon}.png',
                  width: 50,
                  height: 50,
                ),
                Row(
                  children: [
                    Icon(Icons.water_drop,
                        size: 12, color: Colors.blue), // Ícone de chuva
                    SizedBox(width: 4),
                    Text(
                      '${forecast.rain.toStringAsFixed(1)}mm', // Mostrando a quantidade de chuva com uma casa decimal
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// Widget para mostrar a linha de previsões do tempo diárias
class DailyWeatherRow extends StatelessWidget {
  final List<DailyWeatherForecast> forecastList;

  DailyWeatherRow({Key? key, required this.forecastList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: forecastList
            .map((forecast) => DailyForecastCard(forecast: forecast))
            .toList(),
      ),
    );
  }
}

// Widget principal para a previsão do tempo diária
class DailyWeatherWidget extends StatelessWidget {
  final GeoPoint location;

  DailyWeatherWidget({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double latitude = location.latitude;
    final double longitude = location.longitude;

    return BlocProvider<WeatherBloc>(
      create: (context) => WeatherBloc(
          weatherApiService:
              OpenWeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!))
        ..add(WeatherRequested(latitude, longitude)),
      child: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadInProgress) {
            return CustomCircularProgressIndicator();
          } else if (state is WeatherLoadSuccess) {
            final forecastList = parseDailyWeatherData(state.weatherData);
            return DailyWeatherRow(forecastList: forecastList);
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
