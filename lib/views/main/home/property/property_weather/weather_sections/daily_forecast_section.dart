import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_icon_mapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_seringueiro/common/models/weather/daily_weather.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_state.dart';
import 'package:intl/intl.dart'; // Necessário para DateFormat

class DailyForecastSection extends StatelessWidget {
  const DailyForecastSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PropertyWeatherBloc, PropertyWeatherState>(
      builder: (context, state) {
        if (state is WeatherLoadInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is WeatherLoadSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Previsão Diária',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              _buildDailyList(state.weather.daily),
            ],
          );
        } else if (state is WeatherLoadFailure) {
          return Center(child: Text('Falha ao carregar dados: ${state.error}'));
        } else {
          return const SizedBox(); // Mudado para SizedBox como uma prática recomendada
        }
      },
    );
  }

  Widget _buildDailyList(List<DailyWeather> dailyForecast) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: dailyForecast.length,
      itemBuilder: (context, index) {
        final item = dailyForecast[index];
        final weekDay = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
        // Obtenha o caminho do ícone baseado na condição do tempo
        final String iconPath =
            WeatherIconMapper.getIconPath(item.weather.first.icon);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: SvgPicture.asset(
              iconPath,
              width: 70,
              height: 70,
            ),
            title: Text(
              DateFormat('EEEE', 'pt_BR')
                  .format(weekDay), // Formata para o dia da semana
            ),
            subtitle: Text(
              'Máx: ${item.temp.max.toStringAsFixed(1)}°C, Mín: ${item.temp.min.toStringAsFixed(1)}°C',
            ),
            trailing:
                Text(item.weather.isNotEmpty ? item.weather.first.main : 'N/A'),
          ),
        );
      },
    );
  }
}
