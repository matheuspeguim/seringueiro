import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/login/login_bloc.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_bloc.dart';
import 'package:flutter_seringueiro/views/registration/email_verification/email_verification_page.dart';
import 'login_page.dart';

class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // Verifica se o usuário está logado
          if (snapshot.hasData) {
            // Usuário está logado, agora verifica se o email foi verificado
            User user = snapshot.data!;
            if (user.emailVerified) {
              // Email verificado, vai para a MainPage
              return MainPage(user: user);
            } else {
              // Email não verificado, vai para a EmailVerificationPage
              return BlocProvider(
                create: (context) => EmailVerificationBloc(),
                child: EmailVerificationPage(),
              );
            }
          } else {
            // Usuário não está logado, mostra a LoginPage envolvida pelo LoginBloc
            return BlocProvider(
              create: (context) => LoginBloc(),
              child: LoginPage(),
            );
          }
        }
        // Enquanto espera por conexão ou dados, mostra um indicador de carregamento
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
