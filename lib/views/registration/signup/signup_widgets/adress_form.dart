import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/widgets/custom_text_field.dart';
import 'package:flutter_seringueiro/common/validators/validators.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController cepController;
  final TextEditingController logradouroController;
  final TextEditingController numeroController;
  final TextEditingController bairroController;
  final TextEditingController cidadeController;
  final TextEditingController estadoController;
  final FocusNode cepFocus;
  final FocusNode logradouroFocus;
  final FocusNode numeroFocus;
  final FocusNode bairroFocus;
  final FocusNode cidadeFocus;
  final FocusNode estadoFocus;

  const AddressForm({
    Key? key,
    required this.cepController,
    required this.logradouroController,
    required this.numeroController,
    required this.bairroController,
    required this.cidadeController,
    required this.estadoController,
    required this.cepFocus,
    required this.logradouroFocus,
    required this.numeroFocus,
    required this.bairroFocus,
    required this.cidadeFocus,
    required this.estadoFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomTextField(
          controller: cepController,
          label: 'CEP',
          validator: Validators.validarCEP,
          focusNode: cepFocus,
          nextFocusNode: logradouroFocus,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: logradouroController,
          label: 'Logradouro',
          validator: Validators.validarRuaOuSitio,
          focusNode: logradouroFocus,
          nextFocusNode: numeroFocus,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: numeroController,
          label: 'Número',
          validator: Validators.validarNumero,
          focusNode: numeroFocus,
          nextFocusNode: bairroFocus,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: bairroController,
          label: 'Bairro',
          validator: Validators.validarBairro,
          focusNode: bairroFocus,
          nextFocusNode: cidadeFocus,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: cidadeController,
          label: 'Cidade',
          validator: Validators.validarCidade,
          focusNode: cidadeFocus,
          nextFocusNode: estadoFocus,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: estadoController,
          label: 'Estado',
          validator: Validators.validarEstado,
          focusNode: estadoFocus,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}
