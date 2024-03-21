import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/views/login/login_page_wrapper.dart';
import 'package:flutter_seringueiro/views/settings/settings_page.dart';
import 'package:flutter_seringueiro/views/user/account_management_page.dart';

class CustomDrawer extends StatefulWidget {
  final Usuario usuario;

  const CustomDrawer({Key? key, required this.usuario}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Future<String> _appVersionFuture;

  @override
  void initState() {
    super.initState();
    _appVersionFuture = _getAppVersion();
  }

  Future<void> _launchURL(String urlString, BuildContext context) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível abrir $urlString')),
      );
    }
  }

  Future<String> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
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
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Sair'),
              onPressed: () async {
                Navigator.of(context).pop();
                await _auth.signOut();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPageWrapper()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      backgroundColor: colorScheme.background,
      child: ListView(
        children: <Widget>[
          UsuarioDrawerHeader(usuario: widget.usuario),
          // Inclua aqui os outros itens do Drawer
          _buildDrawerItem(
            context: context,
            icon: Icons.settings,
            text: 'Preferências',
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsPage())),
          ),
          Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.account_box,
            text: 'Gerenciar Conta',
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AccountManagementPage(usuario: widget.usuario))),
          ),

          Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.privacy_tip,
            text: 'Política de privacidade',
            onTap: () => _launchURL(
                'https://www.seringueiro.peguim.com.br/privacidade', context),
          ),
          Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.help,
            text: 'Relatar um problema',
            onTap: () {},
          ),
          Divider(),
          _buildDrawerItem(
            context: context,
            icon: Icons.info,
            text: 'Versão do aplicativo',
            futureSubtitle: _appVersionFuture,
          ),
          _buildDrawerItem(
            context: context,
            icon: Icons.logout,
            text: 'Sair',
            onTap: () => _showSignOutConfirmation(context),
          ),
          // Continue com os outros itens, como preferências, gerenciar conta, etc.
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String text,
    String? subtitle,
    VoidCallback? onTap,
    Future<String>? futureSubtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: Icon(icon, color: colorScheme.onBackground),
      title: Text(text, style: textTheme.bodyText1),
      subtitle: futureSubtitle == null
          ? (subtitle != null
              ? Text(subtitle, style: textTheme.bodyText2)
              : null)
          : FutureBuilder<String>(
              future: futureSubtitle,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  return Text(snapshot.data!, style: textTheme.bodyText2);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Text('Carregando...', style: textTheme.bodyText2);
                } else {
                  return Text('Não disponível', style: textTheme.bodyText2);
                }
              },
            ),
      onTap: onTap,
    );
  }
}
