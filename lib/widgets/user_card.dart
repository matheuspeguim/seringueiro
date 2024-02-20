import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final DocumentSnapshot userData;
  final DocumentSnapshot propertyUserData;
  final VoidCallback onRolesEdit;
  final VoidCallback onDelete;

  UserCard({
    required this.userData,
    required this.propertyUserData,
    required this.onRolesEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = userData.data() as Map<String, dynamic>;
    Map<String, dynamic> propertyUser =
        propertyUserData.data() as Map<String, dynamic>;

    return Card(
        color: Colors.black.withOpacity(0.3),
        margin: EdgeInsets.all(8.0),
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            ListTile(
              leading: CircleAvatar(
                // Use a placeholder if the `photoUrl` is not available
                backgroundImage:
                    NetworkImage(user['photoUrl'] ?? 'path_to_default_image'),
              ),
              title: Text(
                user['nome'] ?? 'Usuário não identificado',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                user['idPersonalizado'] ?? '',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
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
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                if (propertyUser['funcoes']['agronomo'])
                  Text('Agrônomo | ',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                if (propertyUser['funcoes']['proprietario'])
                  Text('Proprietário | ',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                if (propertyUser['funcoes']['admin'])
                  Text('Administrador',
                      style: TextStyle(
                        color: Colors.white,
                      )),
              ],
            ),
          ]),
        ));
  }
}
