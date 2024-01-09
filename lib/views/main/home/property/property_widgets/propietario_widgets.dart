import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class ProprietarioWidgets {
  static List<Widget> buildProprietarioWidgets(Property property) {
    // Aqui, o método retorna uma lista de widgets.
    return [
      Divider(),
      Align(
        alignment: Alignment(-0.85, -1.00), // Define o alinhamento à esquerda
        child: Text(
          'Proprietário',
          style: TextStyle(fontSize: 12.0, color: Colors.green),
        ),
      ),
    ];
  }
}
