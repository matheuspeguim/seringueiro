import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/usuario.dart';

class AccountManagementPage extends StatelessWidget {
  final Usuario usuario;
  final String iconUsuario =
      'https://firebasestorage.googleapis.com/v0/b/seringueiroapp.appspot.com/o/profilePictures%2Fvecteezy_illustration-of-human-icon-vector-user-symbol-icon-modern_8442086.jpg?alt=media&token=cdadba3c-68db-4d1b-ace3-b18d7b4733a2';

  AccountManagementPage({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar dados de usuário')),
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
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
