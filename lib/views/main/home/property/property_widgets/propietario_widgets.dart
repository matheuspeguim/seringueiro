import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class ProprietarioWidgets {
  static List<Widget> buildProprietarioWidgets(Property property) {
    // Aqui, o método retorna uma lista de widgets.
    return [
      // Você pode adicionar mais widgets à lista conforme necessário
      Column(
        children: [
          Text(
            "Proprietário widgets",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          // Adicione aqui outros widgets específicos
        ],
      ),
    ];
  }
}
