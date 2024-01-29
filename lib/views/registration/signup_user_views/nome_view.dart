import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/validators/form_validators.dart';

class NomeView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomeController;

  NomeView({Key? key, required this.formKey, required this.nomeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Para nos conhecer-mos melhor, digite abaixo seu nome completo.',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            TextFormField(
              controller: nomeController,
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelText: 'Nome completo',
              ),
              validator: FormValidators.validarNome,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            // Adicione mais campos ou botões se necessário
          ],
        ),
      ),
    );
  }
}
