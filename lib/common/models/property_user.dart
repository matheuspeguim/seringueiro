import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/views/user/profile_page/profile_page.dart';

class PropertyUser {
  final String id;
  final String uid;
  final String propertyId;
  final bool administrador;
  final bool seringueiro;
  final bool agronomo;
  final bool proprietario;

  PropertyUser({
    required this.id,
    required this.uid,
    required this.propertyId,
    this.administrador = false,
    this.seringueiro = false,
    this.agronomo = false,
    this.proprietario = false,
  });

  factory PropertyUser.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return PropertyUser(
      id: doc.id,
      uid: data['uid'],
      propertyId: data['propertyId'],
      administrador: data['admin'] ?? false,
      seringueiro: data['seringueiro'] ?? false,
      agronomo: data['agronomo'] ?? false,
      proprietario: data['proprietario'] ?? false,
    );
  }
}

class PropertyUserListItem extends StatelessWidget {
  final PropertyUser propertyUser;
  final bool editOption;

  PropertyUserListItem({
    Key? key,
    required this.propertyUser,
    this.editOption = false,
  }) : super(key: key);

  Future<Usuario?> _fetchUserDetails(String userId) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return docSnapshot.exists ? Usuario.fromMap(docSnapshot.data()!) : null;
  }

  String _getUserRoles(PropertyUser propertyUser) => [
        if (propertyUser.administrador) 'Administrador',
        if (propertyUser.seringueiro) 'Seringueiro',
        if (propertyUser.agronomo) 'Agrônomo',
        if (propertyUser.proprietario) 'Proprietário',
      ].join(', ');

  void _showEditOptionsDialog(BuildContext context, PropertyUser propertyUser) {
    final permissions = {
      'Administrador': propertyUser.administrador,
      'Seringueiro': propertyUser.seringueiro,
      'Agrônomo': propertyUser.agronomo,
      'Proprietário': propertyUser.proprietario,
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Editar Usuário'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: permissions.entries.map((entry) {
                    return CheckboxListTile(
                      value: entry.value,
                      title: Text(entry.key),
                      onChanged: (bool? value) {
                        setState(() => permissions[entry.key] = value!);
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: [
                Row(
                  children: [
                    TextButton(
                      child: const Text('Excluir Usuário',
                          style: TextStyle(color: Colors.red)),
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // Fecha o diálogo de edição
                        _confirmDeleteUserDialog(context, propertyUser);
                      },
                    ),
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    TextButton(
                      child: const Text('Salvar'),
                      onPressed: () {
                        _updateUserPermissions(
                            context, propertyUser, permissions);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _updateUserPermissions(BuildContext context,
      PropertyUser propertyUser, Map<String, bool> permissions) async {
    // Convertendo as permissões para os nomes de campo corretos usados no Firestore
    final firestorePermissions = {
      'admin': permissions['Administrador']!,
      'seringueiro': permissions['Seringueiro']!,
      'agronomo': permissions['Agrônomo']!,
      'proprietario': permissions['Proprietário']!,
    };

    try {
      await FirebaseFirestore.instance
          .collection('property_users')
          .doc(propertyUser.id)
          .update(firestorePermissions);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Permissões atualizadas com sucesso!")));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao atualizar permissões.")));
    }
  }

  void _confirmDeleteUserDialog(
      BuildContext context, PropertyUser propertyUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: const Text("Você realmente deseja excluir este usuário?"),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                _deleteUser(context, propertyUser);
                Navigator.of(context).pop(); // Fecha o diálogo de confirmação
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUser(
      BuildContext context, PropertyUser propertyUser) async {
    try {
      await FirebaseFirestore.instance
          .collection('property_users')
          .doc(propertyUser.id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Usuário excluído com sucesso.")));
    } catch (error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Erro ao excluir usuário.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: _fetchUserDetails(propertyUser.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(title: Text('Carregando...'));
        }

        if (!snapshot.hasData) {
          return const ListTile(title: Text('Usuário não encontrado'));
        }

        final usuario = snapshot.data!;
        return ListTile(
          leading: CircleAvatar(
              backgroundImage: NetworkImage(usuario.profilePictureUrl)),
          title: Text(usuario.nome,
              style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text('Funções: ${_getUserRoles(propertyUser)}'),
          trailing: editOption
              ? IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () =>
                      _showEditOptionsDialog(context, propertyUser))
              : null,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ProfilePage(usuario: usuario))),
        );
      },
    );
  }
}
