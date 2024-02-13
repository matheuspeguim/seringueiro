import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/usuario.dart';

class ProfilePage extends StatelessWidget {
  final Usuario usuario;
  final String iconUsuario =
      'https://firebasestorage.googleapis.com/v0/b/seringueiroapp.appspot.com/o/profilePictures%2Fvecteezy_illustration-of-human-icon-vector-user-symbol-icon-modern_8442086.jpg?alt=media&token=cdadba3c-68db-4d1b-ace3-b18d7b4733a2';

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
              backgroundImage: NetworkImage(
                usuario.profilePictureUrl != null &&
                        usuario.profilePictureUrl!.isNotEmpty
                    ? usuario.profilePictureUrl!
                    : iconUsuario,
              ),
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
              'Data de Nascimento: ${usuario.nascimento.toLocal().toString().split(' ')[0]}',
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
