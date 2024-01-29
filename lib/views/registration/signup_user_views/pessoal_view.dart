import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/validators/form_validators.dart';

class PessoalView extends StatelessWidget {
  final TextEditingController nomeController;
  final MaskedTextController cpfController;
  final TextEditingController rgController;
  final MaskedTextController nascimentoController;
  final TextEditingController idPersonalizadoController;

  PessoalView(
      {Key? key,
      required this.nomeController,
      required this.cpfController,
      required this.rgController,
      required this.nascimentoController,
      required this.idPersonalizadoController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String nome = nomeController.text.split(" ").first;
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Ótimo, $nome!\nAgora precisamos de alguns detalhes adicionais. Por favor, preencha seus dados pessoais abaixo.',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
              controller: cpfController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CPF',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarCPF),
          TextFormField(
              controller: rgController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: 'RG',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarRG),
          TextFormField(
              controller: nascimentoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Data de nascimento',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarNascimento),
          TextFormField(
              controller: idPersonalizadoController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Nome de usuário',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarIdPersonalizado),
          // Adicione mais campos ou botões se necessário
        ],
      ),
    );
  }
}
