// custom_drawer.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_seringueiro/models/usuario.dart';
import 'package:flutter_seringueiro/views/login/login_page_wrapper.dart';
import 'package:flutter_seringueiro/views/settings/settings_page.dart';
import 'package:flutter_seringueiro/views/user/account_management_page.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Usuario usuario;

  CustomDrawer({Key? key, required this.usuario}) : super(key: key);

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Não foi possível abrir $urlString';
    }
  }

  void _showSignOutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Saída'),
          content: Text('Você tem certeza de que deseja sair?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sair'),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
            ),
          ],
        );
      },
    );
  }

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
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SettingsPage()),
            );
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('Gerenciar Conta'),
          onTap: () => {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AccountManagementPage(usuario: usuario)))
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text('Política de privacidade'),
          onTap: () {
            _launchURL('https://www.seringueiro.com/politicadeprivacidade');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.help),
          title: Text('Relatar um problema'),
          onTap: () => {},
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.info),
          title: Text('Versão do aplicativo'),
          subtitle: Text('1.0.0'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('Sair'),
          onTap: () => _showSignOutConfirmation(context),
        ),
      ]),
    );
  }
}
