import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class AgronomoWidgets {
  static List<Widget> buildAgronomoWidgets(
    BuildContext context,
    User user,
    Property property,
  ) {
    return [
      Divider(),
      Align(
        alignment: Alignment(-0.85, -1.00),
        child: Text(
          'Agrônomo',
          style: TextStyle(fontSize: 12.0, color: Colors.green),
        ),
      ),
      SizedBox(height: 8),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: 8, // Espaçamento horizontal entre os widgets
        runSpacing: 16, // Espaçamento vertical entre as linhas
        children: [
          buildAnaliseButton(context, user, property),
          buildAvaliacaoButton(user, property),
          // Adicione aqui outros widgets específicos para seringueiro
        ],
      )
    ];
  }

  static Widget buildAnaliseButton(
      BuildContext context, User user, Property property) {
    return ElevatedButton.icon(
      onPressed: () => {},
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        'Análise',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget buildAvaliacaoButton(user, property) {
    return ElevatedButton.icon(
      onPressed: () => {},
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        'Avaliação',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  // Outros widgets
}
