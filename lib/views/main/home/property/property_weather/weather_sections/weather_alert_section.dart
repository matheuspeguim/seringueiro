import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_alert.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_state.dart';

class WeatherAlertsSection extends StatelessWidget {
  const WeatherAlertsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyWeatherBloc, PropertyWeatherState>(
      builder: (context, state) {
        if (state is WeatherLoadInProgress) {
          return Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadSuccess &&
            state.weather.alerts.isNotEmpty) {
          return Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Alerta em vigor',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              _buildAlertsList(state.weather.alerts),
            ],
          );
        } else if (state is WeatherLoadFailure) {
          return Center(child: Text('Falha ao carregar dados: ${state.error}'));
        } else {
          // Este else abrange tanto o WeatherLoadSuccess com alerts vazio quanto estados iniciais ou não previstos
          return Container(); // Ou alguma mensagem indicando que não há alertas
        }
      },
    );
  }

  Widget _buildAlertsList(List<WeatherAlert> alerts) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: alerts.length,
      itemBuilder: (context, index) {
        WeatherAlert alert = alerts[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ExpansionTile(
            title: Text(alert.event,
                style: TextStyle(fontWeight: FontWeight.bold)),
            leading: Icon(Icons.warning, color: Colors.red),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                        'De: ${DateTime.fromMillisecondsSinceEpoch(alert.start * 1000)}'),
                    Text(
                        'Até: ${DateTime.fromMillisecondsSinceEpoch(alert.end * 1000)}'),
                    SizedBox(height: 10),
                    Text(alert.description),
                    SizedBox(height: 10),
                    Text('Tags: ${alert.tags.join(', ')}'),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
