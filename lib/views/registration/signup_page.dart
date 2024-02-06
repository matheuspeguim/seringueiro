import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/validators/validators.dart';
import 'package:flutter_seringueiro/views/registration/signup_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup_event.dart';
import 'package:flutter_seringueiro/views/registration/signup_state.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_info_page.dart';

class SignUpPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _isFormValid = false;

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Criar conta',
            style: TextStyle(color: Colors.white, fontSize: 33.0)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpLoading) {
            Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SignUpSuccess) {
            // Navega para PersonalInfoPage após sucesso no registro
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (_) => PersonalBloc(),
                      child: PersonalInfoPage(user: state.user),
                    )));
          } else if (state is SignUpFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error), backgroundColor: Colors.red),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                validator: Validators.validarEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: _senhaController,
                validator: Validators.validarSenha,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                obscureText: true,
              ),
              SizedBox(height: 32.0),
              TextFormField(
                controller: _confirmarSenhaController,
                validator: (valor) {
                  // Chama validarConfirmaSenha com a senha atual e a confirmação de senha
                  return Validators.validarConfirmaSenha(
                      valor ?? '', _senhaController.text);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Confirmar senha',
                    labelStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )),
                style: TextStyle(color: Colors.white, fontSize: 18.0),
                obscureText: true,
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                child: Text('Próximo'),
                onPressed: () {
                  if (_validateForm()) {
                    BlocProvider.of<SignUpBloc>(context).add(
                      SignUpSubmitted(
                        email: _emailController.text,
                        senha: _senhaController.text,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    // Validação do formulário inteiro
    String? emailError = Validators.validarEmail(_emailController.text);
    String? passwordError = Validators.validarSenha(_senhaController.text);
    String? confirmPasswordError = Validators.validarConfirmaSenha(
        _confirmarSenhaController.text, _senhaController.text);

    return emailError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }
}
