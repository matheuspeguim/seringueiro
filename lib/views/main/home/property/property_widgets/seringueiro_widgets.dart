import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';
import 'package:flutter_seringueiro/common/widgets/custom_button.dart';

class SeringueiroWidgets {
  static List<Widget> buildSeringueiroWidgets(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    List<Widget> widgets = [];

    widgets.add(buildSangriaButton(context, user, property, activityManager));
    widgets
        .add(buildEstimulacaoButton(context, user, property, activityManager));
    widgets
        .add(buildTratamentoButton(context, user, property, activityManager));

    return widgets;
  }

  static Widget buildSangriaButton(
    BuildContext context,
    User user,
    Property property,
    FieldActivityManager activityManager,
  ) {
    String activity = "Sangria";
    return CustomButton(
      label: 'Sangria',
      icon: Icons.add,
      onPressed: () async {
        await activityManager.iniciarAtividade(
          context,
          user,
          property,
          activity,
        );
        // Após iniciar a atividade, fecha o ModalBottomSheet
        Navigator.pop(context);
      },
    );
  }

  static Widget buildEstimulacaoButton(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    String activity = "Estimulação";
    return CustomButton(
      label: 'Estimulação',
      icon: Icons.add,
      onPressed: () async {
        await activityManager.iniciarAtividade(
          context,
          user,
          property,
          activity,
        );
        // Após iniciar a atividade, fecha o ModalBottomSheet
        Navigator.pop(context);
      },
    );
  }

  static Widget buildTratamentoButton(BuildContext context, User user,
      Property property, FieldActivityManager activityManager) {
    String activity = "Tratamento";
    return CustomButton(
      label: "Tratamento",
      icon: Icons.add,
      onPressed: () async {
        await activityManager.iniciarAtividade(
          context,
          user,
          property,
          activity,
        );
        // Após iniciar a atividade, fecha o ModalBottomSheet
        Navigator.pop(context);
      },
    );
  }
}
