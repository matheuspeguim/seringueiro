import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/property.dart';

class ProprietarioWidgets {
  static List<Widget> buildProprietarioWidgets(Property property) {
    List<Widget> widgets = [];

    // Adicionar botões e widgets relacionados ao proprietário aqui
    // Exemplo: widgets.add(SeuBotaoDeProprietario());

    // Por enquanto, retornando apenas um divisor e um cabeçalho
    widgets.add(SizedBox(
      height: 0,
    ));

    // Adicionar mais widgets conforme necessário

    return widgets;
  }

  // Aqui você pode adicionar métodos para criar botões específicos do proprietário
  // static Widget SeuBotaoDeProprietario() {
  //   return SeuBotaoWidget(...);
  // }
}
