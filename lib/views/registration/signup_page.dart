import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_info_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _celularController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _celularController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  //VALIDATOR DE EMAIL
  String? validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu e-mail';
    }

    // Expressão regular para validar o e-mail
    RegExp regex = RegExp(
        r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

    if (!regex.hasMatch(valor)) {
      return 'Por favor, insira um e-mail válido';
    }

    return null; // E-mail válido
  }

  //VALIDATOR DE CELULAR
  String? validarCelular(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, insira seu número de celular';
    }

    // Remove espaços, traços e parênteses
    String celular = valor.replaceAll(RegExp(r'[^\d]'), '');

    if (celular.length != 11) {
      return 'O celular deve ter 11 dígitos';
    }

    if (!celular.startsWith('9', 2)) {
      return 'O número deve começar com 9 após o DDD';
    }

    return null; // Número de celular válido
  }

  //VALIDATOR DE SENHA
  String? validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Informe uma senha';
    }
    if (valor.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }
    if (!RegExp(r'[a-z]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos uma letra minúscula';
    }
    if (!RegExp(r'[A-Z]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos uma letra maiúscula';
    }
    if (!RegExp(r'[0-9]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos um número';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(valor)) {
      return 'A senha deve conter pelo menos um caractere especial';
    }
    return null;
  }

  //VALIDATOR DE CONFIRMAÇÃO DE SENHA
  String? validarConfirmaSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Confirme sua senha';
    }
    if (valor != _senhaController.text) {
      return 'As senhas não correspondem';
    }
    return null;
  }

  bool _validateForm() {
    // Validação do formulário inteiro
    String? emailError = validarEmail(_emailController.text);
    String? celularError = validarCelular(_celularController.text);
    String? passwordError = validarSenha(_senhaController.text);
    String? confirmPasswordError =
        validarConfirmaSenha(_confirmarSenhaController.text);

    return emailError == null &&
        celularError == null &&
        passwordError == null &&
        confirmPasswordError == null;
  }

  Future<void> _registerAccount() async {
    if (!_validateForm()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, corrija os erros no formulário.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _senhaController.text,
      );
      if (newUser.user != null) {
        // Verifica se o widget ainda está montado antes de navegar
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => PersonalBloc(),
                child: PersonalInfoPage(user: newUser.user!),
              ),
            ),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      if (e.code == 'weak-password') {
        message = 'Crie uma senha mais forte';
      } else if (e.code == 'email-already-in-use') {
        message = 'Já existe um usuário com este e-mail.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text(
          'Criar conta',
          style: TextStyle(color: Colors.white, fontSize: 33.0),
        ),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      validator: validarEmail,
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
                      controller: _celularController,
                      validator: validarCelular,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Celular',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: _senhaController,
                      validator: validarSenha,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      onChanged: (valor) {
                        setState(() {
                          _isFormValid = validarSenha(valor) == null;
                        });
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      validator: validarConfirmaSenha,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Confirmar senha',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          )),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      onChanged: (valor) {
                        setState(() {
                          _isFormValid = validarSenha(valor) == null;
                        });
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      child: Text('Próximo'),
                      onPressed: () {
                        if (_validateForm()) {
                          _registerAccount();
                        } else {
                          // Exibir mensagem de erro
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Por favor, preencha o formulário corretamente.')));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
