import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/users/property_users_page.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';

class AdminWidgets {
  static List<Widget> buildAdminWidgets(
      BuildContext context, Property property) {
    List<Widget> widgets = [];

    // Adicionar todos os widgets relacionados ao administrador
    widgets.add(buildUsersManager(context, property));

    // Adicionar mais widgets conforme necessário

    return widgets;
  }

  static Widget buildUsersManager(context, property) {
    return CustomButton(
      label: 'Gerenciar',
      icon: Icons.settings,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyUsersPage(propertyId: property.id),
          ),
        );
      },
    );
  }
}
