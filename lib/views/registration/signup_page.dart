import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/validators/contact_info_validator.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/personal/personal_info_page.dart';
import 'package:url_launcher/url_launcher.dart';

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

  final _emailFocus = FocusNode();
  final _celularFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmarSenhaFocus = FocusNode();
  bool _isLoading = false;
  bool _privacyPolicyAccept = false;
  bool _termsOfUseAccepted = false;
  bool _lgpdAgreementAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _celularController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    _emailFocus.dispose();
    _celularFocus.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    super.dispose();
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
    String? emailError =
        ContactInfoValidator.validarEmail(_emailController.text);
    String? celularError =
        ContactInfoValidator.validarCelular(_celularController.text);
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
      backgroundColor: Colors.green.shade100,
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
                      focusNode: _emailFocus,
                      validator: ContactInfoValidator.validarEmail,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'E-mail',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                          )),
                      style: TextStyle(fontSize: 18.0),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_celularFocus);
                      },
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: _senhaController,
                      focusNode: _senhaFocus,
                      validator: validarSenha,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                          )),
                      style: TextStyle(fontSize: 18.0),
                      onChanged: (valor) {
                        setState(() {});
                      },
                      obscureText: true,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_confirmarSenhaFocus);
                      },
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      focusNode: _confirmarSenhaFocus,
                      validator: validarConfirmaSenha,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: 'Confirmar senha',
                          labelStyle: TextStyle(
                            fontSize: 18.0,
                          )),
                      style: TextStyle(fontSize: 18.0),
                      onChanged: (valor) {
                        setState(() {});
                      },
                      onFieldSubmitted: (value) {
                        if (_validateForm()) {
                          _registerAccount();
                        } else {
                          // Exibir mensagem de erro
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Por favor, preencha o formulário corretamente.')));
                        }
                      },
                      obscureText: true,
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _privacyPolicyAccept,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _privacyPolicyAccept = newValue ?? false;
                            });
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Declaro que li e concordo com a ',
                                    style: TextStyle(color: Colors.black)),
                                TextSpan(
                                  text: 'Política de privacidade',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse(
                                          'https://www.seringueiro.com/politicadeprivacidade');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Não foi possível abrir $url';
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _termsOfUseAccepted,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _termsOfUseAccepted = newValue ?? false;
                            });
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Declaro que li e concordo com os ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                TextSpan(
                                  text: 'Termos de uso',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse(
                                          'https://www.seringueiro.com/termosdeuso');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Não foi possível abrir $url';
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(),
                    Row(
                      children: <Widget>[
                        Checkbox(
                          value: _lgpdAgreementAccepted,
                          onChanged: (bool? newValue) {
                            setState(() {
                              _lgpdAgreementAccepted = newValue ?? false;
                            });
                          },
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        'Estou ciente e de acordo com a maneira que meus dados são tratados, de acordo com a  ',
                                    style: TextStyle(
                                      color: Colors.black,
                                    )),
                                TextSpan(
                                  text: 'Lei Geral de Proteção de Dados (LGPD)',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      final Uri url = Uri.parse(
                                          'https://www.seringueiro.com/termosdeuso');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        throw 'Não foi possível abrir $url';
                                      }
                                    },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 32,
                    ),
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
