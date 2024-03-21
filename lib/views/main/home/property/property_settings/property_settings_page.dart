import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/common/widgets/custom_button.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_settings/property_settings_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_settings/property_settings_state.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_settings/property_settings_event.dart';

class PropertySettingsPage extends StatelessWidget {
  final Property property;

  const PropertySettingsPage({Key? key, required this.property})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PropertySettingsBloc>(
      create: (context) =>
          PropertySettingsBloc()..add(LoadPropertySettings(property.id)),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Configurações da Propriedade'),
        ),
        body: BlocBuilder<PropertySettingsBloc, PropertySettingsState>(
          builder: (context, state) {
            if (state is PropertySettingsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PropertySettingsAdmin) {
              return _buildAdminView(context, state);
            } else if (state is PropertySettingsUser) {
              return _buildUserView(context);
            } else if (state is PropertySettingsError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Estado desconhecido.'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildAdminView(BuildContext context, PropertySettingsAdmin state) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Dados da Propriedade:',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        ListTile(
          trailing: Icon(Icons.edit),
          title: Text('Nome: ${property.nomeDaPropriedade}'),
          onTap: () => _showEditPropertyNameDialog(
              context, property.id, property.nomeDaPropriedade),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Gerenciar Usuários:',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        CustomButton(
          label: 'Adicionar usuário',
          icon: Icons.add,
          onPressed: () => _showAddUserDialog(context, property.id),
          elevation: 10,
        ),
        ...state.users.map((user) =>
            PropertyUserListItem(propertyUser: user, editOption: true)),
      ],
    );
  }

  void _showEditPropertyNameDialog(
      BuildContext context, String propertyId, String currentName) {
    // Cria um TextEditingController com o nome atual da propriedade
    TextEditingController _controller =
        TextEditingController(text: currentName);

    // Mostra o AlertDialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Nome da Propriedade'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: "Novo nome da propriedade",
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: Text('Salvar'),
              onPressed: () async {
                // Atualiza o nome da propriedade no Firestore
                final String newName = _controller.text.trim();
                if (newName.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('properties')
                      .doc(propertyId)
                      .update({'nomeDaPropriedade': newName})
                      .then((_) => Navigator.of(context)
                          .pop()) // Fecha o diálogo após a atualização
                      .catchError((error) {
                        // Trata erros de atualização, opcionalmente mostrando um Snackbar ou um diálogo de erro
                        print(
                            "Erro ao atualizar o nome da propriedade: $error");
                        Navigator.of(context)
                            .pop(); // Fecha o diálogo mesmo se houver erro
                      });
                } else {
                  // Opcional: Trate o caso de o nome estar vazio
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddUserDialog(BuildContext context, String propertyId) {
    // Implemente a lógica para adicionar um novo usuário.
    // Use propertyId para associar o usuário à propriedade correta.
  }

  Widget _buildUserView(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Sair da Propriedade'),
          onTap: () => _confirmLeaveProperty(context, property.id),
        ),
      ],
    );
  }

  void _confirmLeaveProperty(BuildContext context, String propertyId) {
    // Mostrar um AlertDialog para confirmar a ação
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("Você realmente deseja sair desta propriedade?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                // Apenas fecha o diálogo se o usuário cancelar
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Sair"),
              onPressed: () {
                // Aqui, dispara o evento para sair da propriedade
                BlocProvider.of<PropertySettingsBloc>(context).add(
                  LeaveProperty(
                      propertyId, FirebaseAuth.instance.currentUser!.uid),
                );

                // Fecha o diálogo após a ação
                Navigator.of(context).pop();

                // Opcionalmente, redirecione o usuário ou mostre um feedback
              },
            ),
          ],
        );
      },
    );
  }
}
