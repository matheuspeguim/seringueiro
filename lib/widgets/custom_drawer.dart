// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/views/login/login_page_wrapper.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPageWrapper()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green.shade900,
      child: ListView(
        children: <Widget>[
          /* DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green.shade800,
            ),
            child: Text(
              'Bem-vindo(a)!',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),*/
          Divider(),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text('Início', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Ação para 'Início'
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text('Configurações', style: TextStyle(color: Colors.white)),
            onTap: () {
              // Ação para 'Configurações'
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: Colors.white),
            title: Text('Sair da conta', style: TextStyle(color: Colors.white)),
            onTap: () => _signOut(context),
          ),
          Divider(),
        ],
      ),
    );
  }
}
