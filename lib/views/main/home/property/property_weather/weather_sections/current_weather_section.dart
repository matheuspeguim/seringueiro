import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_weather/weather_widgets/hourly_temperature_list_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_icon_mapper.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';
import 'package:intl/intl.dart';

class CurrentWeatherSection extends StatelessWidget {
  final WeatherResponse weather;

  const CurrentWeatherSection({
    Key? key,
    required this.weather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var currentWeather = weather.current;
    var currentCondition =
        currentWeather.weather.isNotEmpty ? currentWeather.weather.first : null;

    String iconPath = '';
    if (currentCondition != null) {
      // Utilizando WeatherIconMapper para obter o caminho do ícone baseado no código da condição climática atual
      iconPath = WeatherIconMapper.getIconPath(currentCondition.icon);
    }

    DateTime date = DateTime.fromMillisecondsSinceEpoch(weather.timestamp *
        1000); // Garanta que o timestamp esteja em milissegundos
    String formattedDate = DateFormat('dd/MM/yyyy - HH:mm')
        .format(date); // Formata a data para o formato desejado

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            Text(
              '${currentWeather.temp.toStringAsFixed(1)}°C',
              style: Theme.of(context)
                  .textTheme
                  .headlineLarge
                  ?.copyWith(color: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            Text(
              currentCondition != null
                  ? currentCondition.description.toString()
                  : 'Desconhecido',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            if (iconPath.isNotEmpty)
              SvgPicture.asset(
                iconPath,
                width: 150,
                height: 150,
              ),
            const SizedBox(height: 20),
            HourlyTemperatureListView(weather: weather),
          ],
        ),
      ),
    );
  }
}
