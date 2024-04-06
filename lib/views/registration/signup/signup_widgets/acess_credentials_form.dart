// Asumindo que 'custom_text_field.dart' é onde o CustomTextField está definido
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/widgets/custom_text_field.dart';
import 'package:flutter_seringueiro/common/validators/validators.dart';

class AccessCredentialsForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final TextEditingController confirmarSenhaController;
  final FocusNode emailFocus;
  final FocusNode senhaFocus;
  final FocusNode confirmarSenhaFocus;
  final FocusNode celularFocus;

  AccessCredentialsForm({
    Key? key,
    required this.emailController,
    required this.senhaController,
    required this.confirmarSenhaController,
    required this.emailFocus,
    required this.senhaFocus,
    required this.confirmarSenhaFocus,
    required this.celularFocus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CustomTextField(
          controller: emailController,
          label: 'E-mail',
          validator: Validators.validarEmail,
          focusNode: emailFocus,
          nextFocusNode: senhaFocus,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: senhaController,
          label: 'Senha',
          validator: Validators.validarSenha,
          focusNode: senhaFocus,
          nextFocusNode: confirmarSenhaFocus,
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        SizedBox(height: 32.0),
        CustomTextField(
          controller: confirmarSenhaController,
          label: 'Confirmar senha',
          validator: (valor) =>
              Validators.validarConfirmaSenha(valor!, senhaController.text),
          focusNode: confirmarSenhaFocus,
          nextFocusNode: celularFocus,
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
      ],
    );
  }
}
