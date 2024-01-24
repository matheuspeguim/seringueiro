import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/usuario.dart';

class AccountManagementPage extends StatelessWidget {
  final Usuario usuario;

  AccountManagementPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar dados de usuário')),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(usuario.profilePictureUrl),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            usuario.nome,
            style: TextStyle(fontSize: 24),
          )
        ],
      )),
    );
  }
}
