import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/common/widgets/custom_button.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity_manager.dart';

class PropertyButtonsWidget extends StatelessWidget {
  User user;
  Property property;
  PropertyUser propertyUser;
  FieldActivityManager activityManager;

  PropertyButtonsWidget(
      {Key? key,
      required this.user,
      required this.property,
      required this.propertyUser,
      required this.activityManager})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        direction: Axis.horizontal,
        spacing: 8.0, // Espaçamento horizontal
        runSpacing: 8.0, // Espaçamento vertical
        alignment: WrapAlignment.start, // Alinhamento dos botões
        children: _createButtonsBasedOnPermissions(context),
      ),
    );
  }

  List<Widget> _createButtonsBasedOnPermissions(BuildContext context) {
    List<Widget> buttons = [];

    // Exemplo: Adiciona botões para o seringueiro
    if (propertyUser.seringueiro) {
      buttons.addAll([
        _createButton(context, 'Sangria',
            () => _performSangriaAction(context, user, property)),
        _createButton(context, 'Estimulação',
            () => _performEstimulacaoAction(context, user, property)),
        _createButton(context, 'Tratamento',
            () => _performTratamentoAction(context, user, property)),
        // Adicione mais botões conforme necessário
      ]);
    }

    // Exemplo para adicionar botões para agrônomos
    if (propertyUser.agronomo) {
      // Adicione mais botões conforme necessário
    }

    // Adiciona botões para outras permissões
    if (propertyUser.administrador) {
      // Exemplo de botão para administrador
    }
    if (propertyUser.proprietario) {
      // Exemplo de botão para proprietário
    }

    return buttons;
  }

  Widget _createButton(
      BuildContext context, String label, VoidCallback onPressed) {
    return CustomButton(
      icon: Icons.add,
      label: label,
      onPressed: onPressed,
    );
  }

  Future<void> _performSangriaAction(
      BuildContext context, User user, Property property) async {
    // Ação específica para a Sangria
    String activity = 'Sangria';
    await activityManager.iniciarAtividade(
      context,
      user,
      property,
      activity,
    );
  }

  Future<void> _performEstimulacaoAction(
      BuildContext context, User user, Property property) async {
    String activity = 'Estimulação';
    await activityManager.iniciarAtividade(
      context,
      user,
      property,
      activity,
    );
  }

  void _performTratamentoAction(
      BuildContext context, User user, Property property) async {
    String activity = 'Tratamento';
    await activityManager.iniciarAtividade(
      context,
      user,
      property,
      activity,
    );
  }

  void _performAvaliacaoSeringalAction(BuildContext context) {
    // Ação específica para Avaliação do Seringal
  }
}
