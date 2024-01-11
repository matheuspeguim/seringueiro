import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/usuario.dart';

class ProfilePage extends StatelessWidget {
  final Usuario usuario;

  ProfilePage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nome),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(usuario.profilePictureUrl),
            ),
            SizedBox(height: 20),
            Text(
              usuario.nome,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'ID Personalizado: ${usuario.idPersonalizado}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Data de Nascimento: ${usuario.dataDeNascimento.toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            // Adicione outros campos conforme necessário
          ],
        ),
      ),
    );
  }
}
