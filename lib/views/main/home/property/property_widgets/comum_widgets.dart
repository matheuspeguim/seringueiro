import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';

class CommonWidgets {
  // Método para construir e retornar todos os widgets comuns
  static List<Widget> buildCommonWidgets(Property property) {
    return [
      buildWeatherAndDetails(property),
      // Aqui você pode adicionar mais chamadas a métodos que retornam outros widgets comuns
      // Exemplo: OutroWidgetComum(property),
    ];
  }

  static Widget buildWeatherAndDetails(Property property) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HourlyWeatherWidget(location: property.localizacao),
        // Outros componentes relacionados ao tempo podem ser adicionados aqui
      ],
    );
  }

  // Aqui você pode definir outros métodos para widgets específicos
}
