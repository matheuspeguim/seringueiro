import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria_manager.dart';

class SeringueiroWidgets {
  static List<Widget> buildSeringueiroWidgets(BuildContext context, User user,
      Property property, SangriaManager sangriaManager) {
    return [
      buildSangriaButton(context, user, property, sangriaManager),
      // Adicione aqui outros widgets específicos para seringueiro
    ];
  }

  static Widget buildSangriaButton(BuildContext context, User user,
      Property property, SangriaManager sangriaManager) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => sangriaManager.toggleSangria(context, user, property),
        icon: Icon(
          sangriaManager.isSangriaIniciada ? Icons.stop : Icons.add,
          color: Colors.white,
        ),
        label: Text(
          sangriaManager.isSangriaIniciada
              ? 'Finalizar Sangria'
              : 'Nova Sangria',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: sangriaManager.isSangriaIniciada
              ? Colors.red.shade700
              : Colors.green.shade700,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  //Outros widgets para seringueiro
}
