import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/widgets/custom_Circular_Progress_indicator.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_event.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Modelo de dados para a previsão horária
class HourlyWeatherForecast {
  final DateTime time;
  final String weatherIcon;
  final double temperature;
  final double precipitation; // Adicionado para precipitação

  HourlyWeatherForecast({
    required this.time,
    required this.weatherIcon,
    required this.temperature,
    required this.precipitation, // Incluir na construção
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
        final temperature = hourlyData['temp'].toDouble() - 273.15;
        final precipitation = hourlyData['rain'] != null
            ? (hourlyData['rain']['1h']?.toDouble() ?? 0.0)
            : 0.0;

        return HourlyWeatherForecast(
          time: time,
          weatherIcon: weatherIcon,
          temperature: temperature,
          precipitation: precipitation,
        );
      })
      .take(24)
      .toList();
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Image.network(
            'http://openweathermap.org/img/wn/${forecast.weatherIcon}.png',
            width: 50,
            height: 50,
          ),
          Row(
            children: [
              Icon(Icons.thermostat, size: 16, color: Colors.orange),
              SizedBox(width: 4),
              Text('${forecast.temperature.toStringAsFixed(1)}°C',
                  style: (TextStyle(color: Colors.white, fontSize: 12))),
            ],
          ),
          if (forecast.precipitation > 0) // Exibir se houver precipitação
            Row(
              children: [
                Icon(
                  Icons.water_drop,
                  size: 16,
                  color: Colors.blue,
                ),
                SizedBox(width: 4),
                Text('${forecast.precipitation.toStringAsFixed(1)}mm',
                    style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
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
class HourlyWeatherWidget extends StatelessWidget {
  final GeoPoint location;

  HourlyWeatherWidget({Key? key, required this.location}) : super(key: key);

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

// Modelo de dados para a previsão diária
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
  var dailyForecasts = weatherData['daily'] as List;
  return dailyForecasts
      .map((dailyData) {
        final date =
            DateTime.fromMillisecondsSinceEpoch(dailyData['dt'] * 1000);
        final weatherIcon = dailyData['weather'][0]['icon'];
        final rain = dailyData['rain']?.toDouble() ?? 0.0;

        return DailyWeatherForecast(
          date: date,
          weatherIcon: weatherIcon,
          rain: rain,
        );
      })
      .take(5)
      .toList();
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
      displayDate = "hoje";
    }

    if (now.day + 1 == forecast.date.day &&
        now.month == forecast.date.month &&
        now.year == forecast.date.year) {
      displayDate = "amanhã";
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
