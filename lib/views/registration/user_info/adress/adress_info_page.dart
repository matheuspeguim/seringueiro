// views/registration/personal_info_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/validators/adress_info_validator.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_event.dart';
import 'package:flutter_seringueiro/views/registration/user_info/adress/adress_state.dart';

class AdressInfoPage extends StatefulWidget {
  final User user;

  AdressInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _AdressInfoPageState createState() => _AdressInfoPageState();
}

class _AdressInfoPageState extends State<AdressInfoPage> {
  final cepController = MaskedTextController(mask: '00000-000');
  final ruaOuSitioController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  var cidadeController = TextEditingController();
  var estadoController = TextEditingController();

  User? currentUser;

  final _formKey = GlobalKey<FormState>();

  //Focus
  final cepFocus = FocusNode();
  final ruaOuSitioFocus = FocusNode();
  final numeroFocus = FocusNode();
  final bairroFocus = FocusNode();
  final cidadeFocus = FocusNode();
  final estadoFocus = FocusNode();

  bool _cidadeEEstadoEnabled = true;

  void _submitCep() {
    if (cepController.text.isNotEmpty && cepController.text.length == 9) {
      BlocProvider.of<AdressBloc>(context).add(
        FetchAdressByCep(cep: cepController.text),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    cepFocus.addListener(() {
      if (!cepFocus.hasFocus) {
        _submitCep();
      }
    });
  }

  @override
  void dispose() {
    cepController.dispose();
    ruaOuSitioController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    cepFocus.dispose();
    ruaOuSitioFocus.dispose();
    numeroFocus.dispose();
    bairroFocus.dispose();
    cidadeFocus.dispose();
    estadoFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green.shade900,
        appBar: AppBar(
          title:
              Text('Dados de endereço', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green.shade900,
          centerTitle: true,
        ),
        body: BlocListener<AdressBloc, AdressState>(
          listener: (context, state) {
            if (state is AdressInfoState) {
              currentUser = widget.user;
              ruaOuSitioController.text = state.rua;
              bairroController.text = state.bairro;
              cidadeController.text = state.cidade;
              estadoController.text = state.estado;

              _cidadeEEstadoEnabled = false;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Campo CEP com integração ViaCEP
                    TextFormField(
                      controller: cepController,
                      focusNode: cepFocus,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'CEP da cidade que você mora',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      validator: AdressInfoValidator.validarCEP,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) {
                        _submitCep();
                        FocusScope.of(context).requestFocus(ruaOuSitioFocus);
                      },
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: ruaOuSitioController,
                            focusNode: ruaOuSitioFocus,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Nome da rua ou sítio',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                            validator: AdressInfoValidator.validarRuaOuSitio,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(numeroFocus);
                            },
                          ),
                        ),
                        SizedBox(width: 32.0),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: numeroController,
                            focusNode: numeroFocus,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              labelText: 'Número',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                            validator: AdressInfoValidator.validarNumero,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(bairroFocus);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    TextFormField(
                      controller: bairroController,
                      focusNode: bairroFocus,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Bairro',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      validator: AdressInfoValidator.validarBairro,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onFieldSubmitted: (_) {
                        if (_cidadeEEstadoEnabled == false) {
                          _onSubmitAdressInfo();
                        } else {
                          FocusScope.of(context).requestFocus(cidadeFocus);
                        }
                      },
                    ),
                    SizedBox(height: 32.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: cidadeController,
                            focusNode: cidadeFocus,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Cidade',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                            validator: AdressInfoValidator.validarCidade,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).requestFocus(estadoFocus);
                            },
                            enabled: _cidadeEEstadoEnabled,
                          ),
                        ),
                        SizedBox(width: 32.0),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: estadoController,
                            focusNode: estadoFocus,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: 'Estado',
                              labelStyle: TextStyle(color: Colors.white),
                            ),
                            style:
                                TextStyle(color: Colors.white, fontSize: 18.0),
                            validator: AdressInfoValidator.validarEstado,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            onFieldSubmitted: (_) {
                              _onSubmitAdressInfo();
                              ;
                            },
                            enabled: _cidadeEEstadoEnabled,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: _onSubmitAdressInfo,
                      child: Text('Continuar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  void _onSubmitAdressInfo() {
    if (_formKey.currentState?.validate() ?? false) {
      // Disparar evento para o AdressBloc
      BlocProvider.of<AdressBloc>(context).add(
        AdressInfoSubmitted(
          user: widget.user,
          cep: cepController.text,
          rua: ruaOuSitioController.text,
          numero: numeroController.text,
          bairro: bairroController.text,
          cidade: cidadeController.text,
          estado: estadoController.text,
        ),
      );

      // Navegar para a próxima página
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(user: widget.user),
        ),
        ModalRoute.withName(
            '/main'), // Remove todas as rotas abaixo da pilha até '/main'
      );
    }
  }
}
