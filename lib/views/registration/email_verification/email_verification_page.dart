// email_verification_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          title: Text('Verificar E-mail'),
        ),
        body: BlocBuilder<EmailVerificationBloc, EmailVerificationState>(
          builder: (context, state) {
            if (state is EmailVerificationLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is EmailVerificationSent) {
              return Center(
                child: Text(
                    'Um e-mail de verificação foi enviado. Por favor, verifique sua caixa de entrada.'),
              );
            } else if (state is EmailVerificationFailed) {
              return Center(
                child: Text(
                    'Falha ao enviar e-mail de verificação: ${state.error}'),
              );
            }
            // Implemente outros estados conforme necessário

            return Center(
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você dispara o evento para enviar o e-mail de verificação
                  BlocProvider.of<EmailVerificationBloc>(context)
                      .add(SendVerificationEmail());
                },
                child: Text('Enviar E-mail de Verificação'),
              ),
            );
          },
        ),
      ),
    );
  }
}
