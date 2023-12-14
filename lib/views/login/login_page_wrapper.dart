import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/main_page.dart';
import 'login_page.dart'; // Ajuste o caminho conforme necessário

class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return MainPage(user: snapshot.data!);
          }
          return LoginPage();
        }
        return CircularProgressIndicator(); // Tela de carregamento
      },
    );
  }
}
