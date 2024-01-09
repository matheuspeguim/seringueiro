import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria_manager.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_dialog_content.dart';

class SeringueiroWidgets {
  static List<Widget> buildSeringueiroWidgets(BuildContext context, User user,
      Property property, SangriaManager sangriaManager) {
    return [
      Divider(),
      Align(
        alignment: Alignment(-0.85, -1.00),
        child: Text(
          'Seringueiro',
          style: TextStyle(fontSize: 12.0, color: Colors.green),
        ),
      ),
      SizedBox(height: 8),
      Wrap(
        alignment: WrapAlignment.start,
        spacing: 8, // Espaçamento horizontal entre os widgets
        runSpacing: 16, // Espaçamento vertical entre as linhas
        children: [
          buildSangriaButton(context, user, property, sangriaManager),
          buildPluviometroButton(context, user, property),
          buildEstimulacaoButton(user, property),
          buildTratamentoButton(user, property),
          // Adicione aqui outros widgets específicos para seringueiro
        ],
      )
    ];
  }

  static Widget buildSangriaButton(BuildContext context, User user,
      Property property, SangriaManager sangriaManager) {
    return ElevatedButton.icon(
      onPressed: () => sangriaManager.toggleSangria(context, user, property),
      icon: Icon(
        sangriaManager.isSangriaIniciada ? Icons.stop : Icons.add,
        color: Colors.white,
      ),
      label: Text(
        sangriaManager.isSangriaIniciada ? 'Finalizar Sangria' : 'Sangria',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: sangriaManager.isSangriaIniciada
            ? Colors.red.shade700
            : Colors.green.shade700,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget buildPluviometroButton(
      BuildContext context, User user, Property property) {
    return ElevatedButton.icon(
      onPressed: () {
        _showRainBottomSheet(
            context); // Chama a função para exibir o menu inferior
      },
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        'Chuva',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue.shade700,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget buildEstimulacaoButton(user, property) {
    return ElevatedButton.icon(
      onPressed: () => {},
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        'Estimulação',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade700,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  static Widget buildTratamentoButton(user, property) {
    return ElevatedButton.icon(
      onPressed: () => {},
      icon: Icon(
        Icons.add,
        color: Colors.white,
      ),
      label: Text(
        'Tratamento',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueGrey.shade700,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: TextStyle(fontSize: 16),
      ),
    );
  }

  // Outros widgets para seringueiro

  // Métodos complementares

  static void _showRainBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.blue.shade800,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Registrar Chuva",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              SizedBox(height: 16.0),
              RainDialogContent(), // Conteúdo do menu
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implemente a lógica para salvar os dados
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Salvar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
