import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/services/via_cep_service.dart';
import 'package:flutter_seringueiro/views/login/login_bloc.dart';
import 'package:flutter_seringueiro/views/login/login_event.dart';
import 'package:flutter_seringueiro/views/login/login_state.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_info_page.dart';
import 'package:flutter_seringueiro/views/registration/user_info/contact/contact_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/contact/contact_info_page.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_info_page.dart';
import 'package:flutter_seringueiro/views/registration/signup_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
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
          } else if (state is PersonalInfoMissing) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<PersonalBloc>(
                    create: (context) => PersonalBloc(),
                    child: PersonalInfoPage(user: state.user),
                  ),
                ));
          } else if (state is AdressInfoMissing) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<AdressBloc>(
                    create: (context) =>
                        AdressBloc(viaCepService: ViaCepService()),
                    child: AdressInfoPage(user: state.user),
                  ),
                ));
          } else if (state is ContactInfoMissing) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<ContactBloc>(
                    create: (context) => ContactBloc(),
                    child: ContactInfoPage(user: state.user),
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
          return Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        labelText: 'E-mail',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        )),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
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
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Disparar evento de login
                        BlocProvider.of<LoginBloc>(context).add(
                          LoginSubmitted(
                              email: emailController.text,
                              senha: senhaController.text),
                        );
                      }
                    },
                    child: Text('Entrar'),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white, // Cor base para o texto
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Novo usuário? '),
                          TextSpan(
                            text: 'Criar uma conta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Cor de destaque
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage()),
                                );
                              },
                            // },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
