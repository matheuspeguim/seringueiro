// views/registration/personal_info_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/blocs/registration/registration_bloc.dart';
import 'package:flutter_seringueiro/blocs/registration/registration_event.dart';
import 'package:flutter_seringueiro/blocs/registration/registration_state.dart';
import 'package:flutter_seringueiro/validators/personal_info_validator.dart';
import 'package:flutter_seringueiro/views/user_data/adress_info_page.dart';
import 'package:intl/intl.dart';

class PersonalInfoPage extends StatefulWidget {
  final User user;

  PersonalInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final nomeController = TextEditingController();
  final nascimentoController = MaskedTextController(mask: '00/00/0000');
  final cpfController = MaskedTextController(mask: '000.000.000-00');
  final rgController = TextEditingController();

  User? currentUser;

  final _formKey = GlobalKey<FormState>();

  //Focus
  final nomeFocus = FocusNode();
  final nascimentoFocus = FocusNode();
  final cpfFocus = FocusNode();
  final rgFocus = FocusNode();

  @override
  void dispose() {
    // É importante sempre descartar os controladores e os focus nodes
    nomeController.dispose();
    nascimentoController.dispose();
    cpfController.dispose();
    rgController.dispose();
    nomeFocus.dispose();
    nascimentoFocus.dispose();
    cpfFocus.dispose();
    rgFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade900,
      appBar: AppBar(
        title: Text('Dados Pessoais', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade900,
        centerTitle: true,
      ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationPersonalInfoSuccess) {
            // Lógica para navegar para a próxima página
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AdressInfoPage(user: widget.user),
            ));
          } else if (state is RegistrationFailure) {
            // Mostrar um erro se houver falha no registro
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
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
                  TextFormField(
                    controller: nomeController,
                    focusNode: nomeFocus,
                    decoration: InputDecoration(
                      labelText: 'Nome completo',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: PersonalInfoValidator.validarNome,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(nascimentoFocus);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: nascimentoController,
                    focusNode: nascimentoFocus,
                    decoration: InputDecoration(
                      labelText: 'Data de nascimento',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: PersonalInfoValidator.validarNascimento,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(cpfFocus);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: cpfController,
                    focusNode: cpfFocus,
                    decoration: InputDecoration(
                      labelText: 'CPF',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: PersonalInfoValidator.validarCPF,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(rgFocus);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: rgController,
                    focusNode: rgFocus,
                    decoration: InputDecoration(
                      labelText: 'RG',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    validator: PersonalInfoValidator.validarRG,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: () {
                      // Verifica se todos os campos do formulário são válidos.
                      bool isFormValid =
                          _formKey.currentState?.validate() ?? false;
                      if (isFormValid) {
                        try {
                          DateTime dataDeNascimento = DateFormat("dd/MM/yyyy")
                              .parseStrict(nascimentoController.text);

                          // Envie o evento para o BLoC aqui
                          BlocProvider.of<RegistrationBloc>(context).add(
                            RegistrationPersonalInfoSubmitted(
                              user: widget.user,
                              nome: nomeController.text,
                              dataDeNascimento: dataDeNascimento,
                              cpf: cpfController.text,
                              rg: rgController.text,
                            ),
                          );
                          // Navegação para a próxima página se a data for válida
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  AdressInfoPage(user: widget.user)));
                        } on FormatException {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Data de nascimento inválida')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Por favor, corrija os erros no formulário antes de continuar.')),
                        );
                      }
                    },
                    child: Text('Continuar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
