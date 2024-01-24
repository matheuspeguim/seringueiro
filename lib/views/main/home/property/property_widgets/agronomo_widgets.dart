import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';

class AgronomoWidgets {
  static List<Widget> buildAgronomoWidgets(
      BuildContext context, User user, Property property) {
    List<Widget> widgets = [];

    widgets.add(buildAnaliseButton(context, user, property));
    widgets.add(buildAvaliacaoButton(context, property));

    return widgets;
  }

  static Widget buildAnaliseButton(context, user, property) {
    return CustomButton(
      label: 'Análise',
      icon: Icons.add,
      onPressed: () => {},
    );
  }

  static Widget buildAvaliacaoButton(user, property) {
    return CustomButton(
      label: "Avaliação",
      icon: Icons.add,
      onPressed: () => {},
    );
  }

  // Outros widgets
}
