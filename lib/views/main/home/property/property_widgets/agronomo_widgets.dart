import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class AgronomoWidgets {
  static List<Widget> buildAgronomoWidgets(Property property) {
    // Aqui, o método retorna uma lista de widgets.
    return [
      // Você pode adicionar mais widgets à lista conforme necessário
      Column(
        children: [
          Text(
            "Agrônomo Widgets",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Adicione aqui outros widgets específicos para agrônomos
        ],
      ),
    ];
  }
}
