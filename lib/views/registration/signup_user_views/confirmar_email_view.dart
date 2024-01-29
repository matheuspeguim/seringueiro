import 'package:flutter/material.dart';

class ConfirmarEmailView extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  ConfirmarEmailView({Key? key, required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Um e-mail de verificação foi enviado para o endereço fornecido. Por favor, acesse sua caixa de entrada e clique no link para ativar sua conta.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          CircularProgressIndicator(),
          // Adicione mais campos ou botões se necessário
        ],
      ),
    );
  }
}
