import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final DocumentSnapshot userData;
  final DocumentSnapshot propertyUserData;
  final VoidCallback onRolesEdit;

  UserCard({
    required this.userData,
    required this.propertyUserData,
    required this.onRolesEdit,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = userData.data() as Map<String, dynamic>;
    Map<String, dynamic> propertyUser =
        propertyUserData.data() as Map<String, dynamic>;

    return Card(
        margin: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            ListTile(
              leading: CircleAvatar(
                // Use a placeholder if the `photoUrl` is not available
                backgroundImage: NetworkImage(user['profilePictureUrl'] ??
                    'https://firebasestorage.googleapis.com/v0/b/seringueiroapp.appspot.com/o/profilePictures%2Fvecteezy_illustration-of-human-icon-vector-user-symbol-icon-modern_8442086.jpg?alt=media&token=cdadba3c-68db-4d1b-ace3-b18d7b4733a2'),
              ),
              title: Text(
                user['nome'] ?? 'Usuário não identificado',
                style: TextStyle(),
              ),
              subtitle: Text(
                user['idPersonalizado'] ?? '',
                style: TextStyle(),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                ),
                onPressed: onRolesEdit,
              ),
            ),
            // Indicadores dos papéis do usuário
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (propertyUser['funcoes']['seringueiro'])
                  Text(
                    'Seringueiro | ',
                  ),
                if (propertyUser['funcoes']['agronomo'])
                  Text(
                    'Agrônomo | ',
                  ),
                if (propertyUser['funcoes']['proprietario'])
                  Text(
                    'Proprietário | ',
                  ),
                if (propertyUser['funcoes']['admin'])
                  Text(
                    'Administrador',
                  ),
              ],
            ),
          ]),
        ));
  }
}
