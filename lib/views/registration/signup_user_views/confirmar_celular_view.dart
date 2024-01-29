import 'package:flutter/material.dart';

class ConfirmarCelularView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController codigoConfirmarCelularController;

  ConfirmarCelularView(
      {Key? key,
      required this.formKey,
      required this.codigoConfirmarCelularController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: codigoConfirmarCelularController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Código de Confirmação do seu celular',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              // Adicione sua lógica de validação de código aqui
            },
          ),
          // Adicione mais campos ou botões se necessário
        ],
      ),
    );
  }
}
