import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'email_verification_bloc.dart';
import 'email_verification_event.dart';
import 'email_verification_state.dart';

class EmailVerificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Acesso ao tema atual
    final theme = Theme.of(context);

    return BlocProvider<EmailVerificationBloc>(
      create: (context) => EmailVerificationBloc(),
      child: Scaffold(
        appBar: AppBar(
          // Utiliza as configurações do tema para AppBar
          title: Text(
            'Verificação de E-mail',
            style: theme.appBarTheme.titleTextStyle,
          ),
        ),
        // Utiliza as cores do tema para o backgroundColor
        backgroundColor: theme.colorScheme.background,
        body: BlocConsumer<EmailVerificationBloc, EmailVerificationState>(
          listener: (context, state) {
            if (state is EmailVerified) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => MainPage(user: state.user)),
                ModalRoute.withName('/main'),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Um e-mail de verificação foi enviado. Por favor, verifique sua caixa de entrada e clique no link para confirmar seu e-mail.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
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
