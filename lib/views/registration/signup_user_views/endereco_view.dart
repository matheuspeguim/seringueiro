import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/validators/form_validators.dart';

class EnderecoView extends StatelessWidget {
  final MaskedTextController cepController;
  final TextEditingController ruaOuSitioController;
  final TextEditingController complementoController;
  final TextEditingController bairroController;
  final TextEditingController numeroController;
  final TextEditingController cidadeController;
  final TextEditingController estadoController;

  EnderecoView(
      {Key? key,
      required this.cepController,
      required this.ruaOuSitioController,
      required this.complementoController,
      required this.bairroController,
      required this.numeroController,
      required this.cidadeController,
      required this.estadoController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Informe seu endereço de residência abaixo.',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(
            height: 16,
          ),
          TextFormField(
              controller: cepController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'CEP',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarCEP),
          TextFormField(
              controller: ruaOuSitioController,
              keyboardType: TextInputType.streetAddress,
              decoration: InputDecoration(
                labelText: 'Digite o nome da sua Rua ou Sítio',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarRuaOuSitio),
          TextFormField(
              controller: complementoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Complemento',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarRuaOuSitio),
          TextFormField(
              controller: bairroController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Bairro',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarBairro),
          TextFormField(
              controller: cidadeController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Cidade',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarCidade),
          TextFormField(
              controller: estadoController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Estado',
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: FormValidators.validarEstado),
          // Adicione mais campos ou botões se necessário
        ],
      ),
    );
  }
}
