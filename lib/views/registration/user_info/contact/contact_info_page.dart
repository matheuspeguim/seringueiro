// views/registration/personal_info_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_seringueiro/validators/Contact_info_validator.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:flutter_seringueiro/views/registration/user_info/contact/contact_bloc.dart';
import 'package:flutter_seringueiro/views/registration/user_info/contact/contact_event.dart';
import 'package:flutter_seringueiro/views/registration/user_info/contact/contact_state.dart';

class ContactInfoPage extends StatefulWidget {
  final User user;

  ContactInfoPage({Key? key, required this.user}) : super(key: key);

  @override
  _ContactInfoPageState createState() => _ContactInfoPageState();
}

class _ContactInfoPageState extends State<ContactInfoPage> {
  final celularController = MaskedTextController(mask: '(00)00000-0000');

  User? currentUser;

  final _formKey = GlobalKey<FormState>();

  //Focus
  final celularFocus = FocusNode();

  @override
  void dispose() {
    celularController.dispose();
    celularFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green.shade900,
        appBar: AppBar(
          title:
              Text('Dados de contato', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green.shade900,
          centerTitle: true,
        ),
        body: BlocListener<ContactBloc, ContactState>(
          listener: (context, state) {
            if (state is ContactLoading) {
              // Mostrar um diálogo de carregamento ou um widget de carregamento
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    Center(child: CircularProgressIndicator()),
              );
            } else if (state is ContactInfoSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(user: widget.user),
                ),
                ModalRoute.withName(
                    '/main'), // Remove todas as rotas abaixo da pilha até '/main'
              );
            } else if (state is ContactFailure) {
              // Lógica para mostrar erro
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
                      controller: celularController,
                      focusNode: celularFocus,
                      decoration: InputDecoration(
                        labelText: 'Celular',
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
                      validator: ContactInfoValidator.validarCelular,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          BlocProvider.of<ContactBloc>(context).add(
                            ContactInfoSubmitted(
                              user: widget.user,
                              celular: celularController.text,
                            ),
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
        ));
  }
}
