// email_verification_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'email_verification_bloc.dart';
import 'email_verification_event.dart';
import 'email_verification_state.dart';

class EmailVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<EmailVerificationBloc>(
      create: (context) => EmailVerificationBloc(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green.shade900,
          title: Text(
            'Verificação de E-mail',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green.shade900,
        body: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
          listener: (context, state) {
            if (state is EmailVerified) {
              // Ajuste a navegação para passar o usuário verificado
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(user: state.user),
                ),
                ModalRoute.withName(
                    '/main'), // Remove todas as rotas abaixo da pilha até '/main'
              );
            } else if (state is EmailVerificationFailed) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Atenção'),
                  content: Text(state.error),
                  actions: <Widget>[
                    TextButton(
                      child: Text('Ok'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment
                    .center, // Alinha os filhos horizontalmente ao centro
                children: [
                  Text(
                    'Um e-mail de verificação foi enviado. Por favor, verifique sua caixa de entrada e clique no link para confirmar seu e-mail.',
                    textAlign: TextAlign
                        .center, // Centraliza o texto dentro do widget Text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<EmailVerificationBloc>(context)
                          .add(CheckEmailVerified());
                    },
                    child: Text('Confirmei meu e-mail'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
