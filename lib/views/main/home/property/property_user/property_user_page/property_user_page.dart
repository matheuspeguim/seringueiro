import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/property_user.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_user/property_user_page/property_user_state.dart';

class PropertyUserPage extends StatelessWidget {
  final String propertyUserId; // ID do PropertyUser

  const PropertyUserPage({
    Key? key,
    required this.propertyUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PropertyUserBloc>(
      create: (context) =>
          PropertyUserBloc()..add(LoadPropertyUserDetails(propertyUserId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Perfil do Membro"),
        ),
        body: BlocConsumer<PropertyUserBloc, PropertyUserState>(
          listener: (context, state) {
            if (state is PropertyUserError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(state.message),
              ));
            }
          },
          builder: (context, state) {
            if (state is PropertyUserLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PropertyUserLoaded) {
              return _buildUserProfile(context, state.propertyUser);
            } else if (state is PropertyUserError) {
              return Center(child: Text('Erro ao carregar o perfil.'));
            }
            return Center(child: Text('Estado desconhecido.'));
          },
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, PropertyUser propertyUser) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            radius: 60,
            backgroundImage:
                NetworkImage(propertyUser.usuario.profilePictureUrl),
            backgroundColor: Colors.grey.shade200,
          ),
          SizedBox(height: 20),
          Text(
            propertyUser.usuario.nome,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text(
            _getUserRoles(propertyUser),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 20),
          Divider(),
          ListTile(
            leading: Icon(Icons.email),
            title: Text(propertyUser.usuario.email),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text(propertyUser.usuario.celular),
          ),
          // Outras informações do usuário podem ser adicionadas aqui.
          if (propertyUser.administrador) ...[
            Divider(),
            ElevatedButton(
              onPressed: () => _showRoleManagementDialog(context, propertyUser),
              child: Text('Gerenciar Funções'),
            ),
            ElevatedButton(
              onPressed: () =>
                  _showDeleteConfirmationDialog(context, propertyUser),
              child: Text('Excluir Usuário da Propriedade'),
            ),
            if (propertyUser.seringueiro)
              ElevatedButton(
                onPressed: () {
                  // Implementar ação para gerenciar contrato de seringueiro
                },
                child: Text('Gerenciar Contrato de Seringueiro'),
              ),
          ]
        ],
      ),
    );
  }

  String _getUserRoles(PropertyUser propertyUser) {
    List<String> roles = [];
    if (propertyUser.administrador) roles.add('Administrador');
    if (propertyUser.seringueiro) roles.add('Seringueiro');
    if (propertyUser.agronomo) roles.add('Agrônomo');
    if (propertyUser.proprietario) roles.add('Proprietário');
    return roles.join(', ');
  }

  void _showRoleManagementDialog(
      BuildContext context, PropertyUser propertyUser) {
    // Implemente a lógica para mostrar o diálogo de gerenciamento de funções
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, PropertyUser propertyUser) {
    // Implemente a lógica para mostrar o diálogo de confirmação de exclusão
  }
}
