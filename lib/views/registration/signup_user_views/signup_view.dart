import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_seringueiro/validators/form_validators.dart';

class SignUpView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController senhaController;
  final TextEditingController confirmarSenhaController;

  SignUpView(
      {Key? key,
      required this.formKey,
      required this.emailController,
      required this.senhaController,
      required this.confirmarSenhaController})
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
                'Digite seu e-mail e senha abaixo.',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Endereço de e-mail',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: FormValidators.validarEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: senhaController,
                keyboardType: TextInputType.name,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Digite sua senha',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: FormValidators.validarSenha,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: confirmarSenhaController,
                keyboardType: TextInputType.name,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirme sua senha',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (valor) => FormValidators.validarConfirmaSenha(
                    valor, senhaController.text),
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
            ],
          )),
    );
  }
}
