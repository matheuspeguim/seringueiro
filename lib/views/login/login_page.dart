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
    // Acesso ao tema atual
    var currentTheme = Theme.of(context);

    return Scaffold(
      backgroundColor: currentTheme.colorScheme.background,
      appBar: AppBar(
        elevation: currentTheme.appBarTheme.elevation ?? 0,
        title: Text(
          'Entrar na conta',
          style: currentTheme.appBarTheme.titleTextStyle,
        ),
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
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is LoginLoading) {
            return Center(child: CircularProgressIndicator());
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
                            labelStyle: currentTheme.textTheme.bodyLarge),
                        style: currentTheme.textTheme.bodyLarge,
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
                          labelStyle: currentTheme.textTheme.bodyLarge,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _senhaVisivel
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: currentTheme.iconTheme.color,
                            ),
                            onPressed: () {
                              setState(() {
                                _senhaVisivel = !_senhaVisivel;
                              });
                            },
                          ),
                        ),
                        style: currentTheme.textTheme.bodyLarge,
                        obscureText: !_senhaVisivel,
                        onFieldSubmitted: (value) => _executarLogin(context),
                      ),
                      SizedBox(height: 16.0),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: currentTheme.colorScheme.onPrimary,
                          backgroundColor:
                              currentTheme.colorScheme.primary, // foreground
                        ),
                        onPressed: () => _executarLogin(context),
                        child: Text('Entrar',
                            style: currentTheme.textTheme.button),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextButton(
                        onPressed: () => _showResetPasswordDialog(context),
                        child: Text("Esqueci minha senha",
                            style: currentTheme.textTheme.button),
                      ),
                      Divider(
                        color: currentTheme.dividerTheme.color,
                        indent: currentTheme.dividerTheme.indent,
                        endIndent: currentTheme.dividerTheme.endIndent,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: currentTheme.textTheme.bodyMedium,
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Novo usuário? ',
                                  style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyMedium?.color)),
                              TextSpan(
                                text: 'Criar uma conta',
                                style: TextStyle(
                                    color: currentTheme.colorScheme.secondary,
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
