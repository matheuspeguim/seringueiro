import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/blocs/login/login_bloc.dart';
import 'login_page.dart'; // Ajuste o caminho conforme necessário

class LoginPageWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: LoginPage(),
    );
  }
}
