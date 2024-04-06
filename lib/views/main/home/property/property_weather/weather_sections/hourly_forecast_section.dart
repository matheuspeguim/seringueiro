import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_icon_mapper.dart';
import 'package:flutter_svg/svg.dart'; // Adicione esta linha para usar SVGs
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/property_weather_state.dart';

// Adicione a classe WeatherIconMapper que você criou anteriormente aqui

class HourlyForecastSection extends StatelessWidget {
  const HourlyForecastSection({Key? key}) : super(key: key);

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
                  'Previsão Horária',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 140.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.weather.hourly.length,
                  itemBuilder: (context, index) {
                    final item = state.weather.hourly[index];
                    final hour =
                        DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
                    return Container(
                      width: 100.0,
                      padding: const EdgeInsets.all(4.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('${hour.hour}:00',
                              style: Theme.of(context).textTheme.bodyMedium),
                          // Substitua Icon por SvgPicture.asset
                          SvgPicture.asset(
                            _getWeatherIcon(item.weather[0]
                                .icon), // Atualizado para usar o ícone da API
                            width: 50.0,
                            height: 50.0,
                          ),
                          Text('${item.temp.toStringAsFixed(1)}°C',
                              style: Theme.of(context).textTheme.bodySmall),
                          Text('${item.precipitation.toStringAsFixed(1)}mm',
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        } else if (state is WeatherLoadFailure) {
          return Center(child: Text('Falha ao carregar dados: ${state.error}'));
        } else {
          return const SizedBox(); // Container vazio substituído por SizedBox para melhores práticas
        }
      },
    );
  }

  // Atualizado para retornar o caminho do ícone como uma String
  String _getWeatherIcon(String iconCode) {
    // Aqui você chamará WeatherIconMapper.getIconPath(iconCode)
    // que você definiu anteriormente para obter o caminho do ícone
    return WeatherIconMapper.getIconPath(iconCode);
  }
}
