import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/widgets/custom_text_field.dart';
import 'package:flutter_seringueiro/common/validators/validators.dart';

class PersonalDetailsForm extends StatelessWidget {
  final TextEditingController idPersonalizadoController;
  final TextEditingController nomeController;
  final TextEditingController nascimentoController;
  final TextEditingController cpfController;
  final TextEditingController rgController;
  final TextEditingController celularController;
  final FocusNode idPersonalizadoFocus;
  final FocusNode nomeFocus;
  final FocusNode nascimentoFocus;
  final FocusNode cpfFocus;
  final FocusNode rgFocus;
  final FocusNode celularFocus;

  PersonalDetailsForm({
    Key? key,
    required this.idPersonalizadoController,
    required this.nomeController,
    required this.nascimentoController,
    required this.cpfController,
    required this.rgController,
    required this.celularController,
    required this.idPersonalizadoFocus,
    required this.nomeFocus,
    required this.nascimentoFocus,
    required this.cpfFocus,
    required this.rgFocus,
    required this.celularFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomTextField(
          controller: idPersonalizadoController,
          label: 'Nome de usuário (sem espaço)',
          validator: Validators.validarIdPersonalizado,
          focusNode: idPersonalizadoFocus,
          nextFocusNode: nomeFocus,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: nomeController,
          label: 'Nome completo',
          validator: Validators.validarNome,
          focusNode: nomeFocus,
          nextFocusNode: nascimentoFocus,
          keyboardType: TextInputType.name,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: nascimentoController,
          label: 'Data de nascimento',
          validator: Validators.validarNascimento,
          focusNode: nascimentoFocus,
          nextFocusNode: cpfFocus,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: cpfController,
          label: 'CPF',
          validator: Validators.validarCPF,
          focusNode: cpfFocus,
          nextFocusNode: rgFocus,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: rgController,
          label: 'RG',
          validator: Validators.validarRG,
          focusNode: rgFocus,
          nextFocusNode: celularFocus,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: celularController,
          label: 'Número de celular',
          validator: Validators.validarCelular,
          focusNode: celularFocus,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }
}
