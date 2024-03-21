import 'package:flutter/material.dart';

class FieldActivityWeatherIcon extends StatelessWidget {
  final Map<String, dynamic> condicoesClimaticas;

  FieldActivityWeatherIcon({Key? key, required this.condicoesClimaticas})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var umidade = condicoesClimaticas['humidity'];
    var temperatura = condicoesClimaticas['temperature'];
    String icone = condicoesClimaticas['icon'];
    String iconeUrl = 'https://openweathermap.org/img/wn/$icone.png';

    // Accessing theme data
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.network(iconeUrl, width: 50),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.thermostat, color: Colors.orange, size: 12),
                  SizedBox(width: 4),
                  Text(
                    '${temperatura.toStringAsFixed(1)}°C',
                    style: theme.textTheme.bodyText2
                        ?.copyWith(color: theme.colorScheme.onSurface),
                  ),
                ],
              ),
              Text(
                'Umidade: $umidade%',
                style: theme.textTheme.bodyText2
                    ?.copyWith(color: theme.colorScheme.onSurface),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
