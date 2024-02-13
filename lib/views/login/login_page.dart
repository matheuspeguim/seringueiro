import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/login/login_bloc.dart';
import 'package:flutter_seringueiro/views/login/login_event.dart';
import 'package:flutter_seringueiro/views/login/login_state.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_bloc.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_page.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_bloc.dart';
import 'package:flutter_seringueiro/views/registration/signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final emailFocus = FocusNode();
  final senhaFocus = FocusNode();
  bool _senhaVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        elevation: 50,
        title: Text('Entrar na conta', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MainPage(user: state.user)),
            );
          } else if (state is EmailNotVerified) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<EmailVerificationBloc>(
                    create: (context) => EmailVerificationBloc(),
                    child: EmailVerificationPage(),
                  ),
                ));
          } else if (state is LoginFailure) {
            // Aqui você pode mostrar uma mensagem de erro
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SingleChildScrollView(
              child: Center(
            heightFactor: 1.5,
            child: Column(children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: emailController,
                        focusNode: emailFocus,
                        decoration: InputDecoration(
                            labelText: 'E-mail',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            )),
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(senhaFocus);
                        },
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Por favor, insira um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32.0),
                      TextFormField(
                        controller: senhaController,
                        focusNode: senhaFocus,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Alterna os ícones
                              _senhaVisivel
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              // Alterna o estado da visibilidade da senha
                              setState(() {
                                _senhaVisivel = !_senhaVisivel;
                              });
                            },
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                        ),
                        obscureText: !_senhaVisivel,
                        onFieldSubmitted: (value) => _executarLogin(context),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () => _executarLogin(context),
                        child: Text('Entrar'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        onPressed: () => _showResetPasswordDialog(context),
                        child: Text("Esqueci minha senha",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ),
                      Divider(
                        indent: 10,
                        endIndent: 10,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Novo usuário? ',
                                  style: TextStyle(color: Colors.white)),
                              TextSpan(
                                text: 'Criar uma conta',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) =>
                                          BlocProvider<SignUpBloc>(
                                        create: (context) => SignUpBloc(),
                                        child: SignUpPage(),
                                      ),
                                    ));
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ]),
          ));
        },
      ),
    );
  }

  void _executarLogin(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Disparar evento de login
      BlocProvider.of<LoginBloc>(context).add(
        LoginWithEmailSubmitted(
            email: emailController.text, senha: senhaController.text),
      );
    }
  }

  void _showResetPasswordDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Redefinir Senha"),
          content: TextFormField(
            controller: emailController,
            decoration: InputDecoration(hintText: "Digite seu e-mail"),
            keyboardType: TextInputType.emailAddress,
          ),
          actions: [
            TextButton(
              child: Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Enviar"),
              onPressed: () {
                _resetPassword(emailController.text, context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetPassword(String email, BuildContext context) async {
    if (email.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Digite um e-mail válido")));
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "E-mail de redefinição enviado! Verifique sua caixa de entrada.")));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao enviar e-mail: $error")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    emailFocus.dispose();
    senhaFocus.dispose();
    super.dispose();
  }
}
