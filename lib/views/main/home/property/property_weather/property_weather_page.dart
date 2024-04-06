import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_sections/current_weather_section.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_sections/daily_forecast_section.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_sections/hourly_forecast_section.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_sections/weather_alert_section.dart';

class PropertyWeatherPage extends StatefulWidget {
  final double latitude;
  final double longitude;

  PropertyWeatherPage(
      {Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  _PropertyWeatherPageState createState() => _PropertyWeatherPageState();
}

class _PropertyWeatherPageState extends State<PropertyWeatherPage> {
  @override
  void initState() {
    super.initState();
    // Inicializa o carregamento dos dados climáticos
    context.read<PropertyWeatherBloc>().add(
        LoadWeather(latitude: widget.latitude, longitude: widget.longitude));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Condições Climáticas'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => context.read<PropertyWeatherBloc>().add(
                LoadWeather(
                    latitude: widget.latitude, longitude: widget.longitude)),
          ),
        ],
      ),
      body: BlocBuilder<PropertyWeatherBloc, PropertyWeatherState>(
        builder: (context, state) {
          if (state is WeatherLoadInProgress) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WeatherLoadSuccess) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  CurrentWeatherSection(
                      weather: state
                          .weather), // Usado sem passar o estado diretamente
                  if (state.weather.alerts.isNotEmpty)
                    WeatherAlertsSection(), // Usado sem passar o estado diretamente
                  HourlyForecastSection(), // Usado sem passar o estado diretamente
                  DailyForecastSection(), // Usado sem passar o estado diretamente
                ],
              ),
            );
          } else if (state is WeatherLoadFailure) {
            return Text(
              'Falha ao carregar dados: ${state.error}',
              style: TextStyle(color: Colors.red),
            );
          }
          return Text('Por favor, aguarde...');
        },
      ),
    );
  }
}
