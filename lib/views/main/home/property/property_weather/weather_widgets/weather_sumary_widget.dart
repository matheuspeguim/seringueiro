import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_icon_mapper.dart';
import 'package:flutter_seringueiro/common/models/weather/weather_response.dart';
import 'package:flutter_seringueiro/common/services/weather_service.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherSummaryWidget extends StatefulWidget {
  final Property property;

  WeatherSummaryWidget({Key? key, required this.property}) : super(key: key);

  @override
  _WeatherSummaryWidgetState createState() => _WeatherSummaryWidgetState();
}

class _WeatherSummaryWidgetState extends State<WeatherSummaryWidget> {
  late Future<WeatherResponse?> _weatherFuture;

  @override
  void initState() {
    super.initState();
    final weatherService = WeatherService();
    _weatherFuture = weatherService.fetchWeather(
      widget.property.localizacao.latitude,
      widget.property.localizacao.longitude,
      forceRefresh: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherResponse?>(
      future: _weatherFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Falha ao carregar dados do clima.');
        } else if (snapshot.hasData) {
          return _buildWeatherSummary(snapshot.data!);
        } else {
          return Text('Dados de clima não disponíveis.');
        }
      },
    );
  }

  Widget _buildWeatherSummary(WeatherResponse weather) {
    final weatherIcon =
        WeatherIconMapper.getIconPath(weather.current.weather.first.icon);
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(weatherIcon, width: 50),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Alinha os ícones ao centro verticalmente com o texto
                  children: [
                    SvgPicture.asset(
                      'assets/weather_icons/thermometer-celsius.svg',
                      width: 24,
                      height:
                          24, // Ícones menores para equilibrar com o tamanho do texto
                    ),
                    SizedBox(
                        width:
                            4), // Espaço horizontal menor para ícones menores
                    Text(
                      '${weather.current.temp.toStringAsFixed(1)}°C',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/weather_icons/humidity.svg',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 4),
                    Text('${weather.current.humidity}% umidade'),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/weather_icons/rain.svg',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(width: 4),
                    Text(
                        '${(weather.daily.first.pop * 100).toStringAsFixed(0)}% de chuva hoje'),
                  ],
                ),
                // Adicione mais informações conforme desejado
              ],
            ),
          ),
        ],
      ),
    );
  }
}
