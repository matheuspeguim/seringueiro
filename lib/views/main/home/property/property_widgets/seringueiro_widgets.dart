import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';
import 'package:flutter_seringueiro/views/main/home/property/rain/rain_dialog_content.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';

class SeringueiroWidgets {
  static List<Widget> buildSeringueiroWidgets(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    List<Widget> widgets = [];

    widgets.add(buildSangriaButton(context, user, property, activityManager));
    widgets.add(buildPluviometroButton(context, user, property));
    widgets
        .add(buildEstimulacaoButton(context, user, property, activityManager));
    widgets
        .add(buildTratamentoButton(context, user, property, activityManager));

    return widgets;
  }

  static Widget buildSangriaButton(context, user, property, activityManager) {
    return CustomButton(
      label: 'Sangria',
      icon: Icons.add,
      onPressed: () => activityManager.toggleActivity(context, user, property),
      backgroundColor: Colors.green,
    );
  }

  static Widget buildPluviometroButton(context, user, property) {
    return CustomButton(
      label: 'Chuva',
      icon: Icons.add,
      onPressed: () {
        _showRainBottomSheet(context);
      },
      backgroundColor: Colors.blue,
    );
  }

  static Widget buildEstimulacaoButton(
      context, user, property, activityManager) {
    return CustomButton(
      label: 'Estimulação',
      icon: Icons.add,
      onPressed: () {},
      backgroundColor: Colors.red,
    );
  }

  static Widget buildTratamentoButton(
      context, user, property, activityManager) {
    return CustomButton(
      label: "Tratamento",
      icon: Icons.add,
      onPressed: () {},
      backgroundColor: Colors.yellow.shade700,
    );
  }
  // Outros widgets para seringueiro

  // Métodos complementares

  static void _showRainBottomSheet(
    BuildContext context,
  ) {
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
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
