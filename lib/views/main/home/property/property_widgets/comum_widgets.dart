import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/weather/weather_page.dart';

class CommonWidgets {
  // Método para construir e retornar todos os widgets comuns
  static List<Widget> buildCommonWidgets(Property property) {
    return [
      buildWeatherAndDetails(property),
      buildSangriaPainel(property),
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

  static Widget buildSangriaPainel(Property property) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.green.shade200,
        margin: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.green.shade800,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              child: Text(
                "Painel de sangria",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Corpo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Adicione mais Widgets aqui para exibir os detalhes da propriedade
                ],
              ),
            ),

            // Rodapé (se necessário, adicione funcionalidades similares ao _buildPropertyCard)
          ],
        ),
      ),
    );
  }

  // Aqui você pode definir outros métodos para widgets específicos
}
