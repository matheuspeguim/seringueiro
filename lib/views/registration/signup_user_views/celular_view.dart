import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/validators/form_validators.dart';

class CelularView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController celularController;

  CelularView(
      {Key? key, required this.formKey, required this.celularController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '',
            style: TextStyle(fontSize: 24),
          ),
          TextFormField(
              controller: celularController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Celular',
              ),
              validator: FormValidators.validarCelular),
          // Adicione mais campos ou botões se necessário
        ],
      ),
    );
  }
}
