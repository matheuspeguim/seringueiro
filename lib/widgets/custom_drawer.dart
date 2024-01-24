// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/models/usuario.dart';
import 'package:flutter_seringueiro/views/login/login_page_wrapper.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Usuario usuario;

  CustomDrawer({Key? key, required this.usuario}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPageWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green.shade100,
      child: ListView(children: <Widget>[
        UsuarioDrawerHeader(usuario: usuario),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Preferências'),
          onTap: () {
            // Ação para 'Configurações'
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('Gerenciar Conta'),
          onTap: () => _signOut(context),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('Política de privacidade'),
          onTap: () => _signOut(context),
        ),
      ]),
    );
  }
}
