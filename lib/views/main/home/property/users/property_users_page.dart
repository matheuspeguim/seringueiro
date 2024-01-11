import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/models/usuario.dart';
import 'package:flutter_seringueiro/views/main/home/property/users/property_users_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/users/property_users_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/users/property_users_state.dart';

class PropertyUsersPage extends StatelessWidget {
  final String propertyId;

  PropertyUsersPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade900,
        title: Text('Usuários da Propriedade',
            style: TextStyle(color: Colors.white)),
      ),
      body: BlocProvider(
          create: (context) =>
              PropertyUsersBloc()..add(FetchPropertyUsers(propertyId)),
          child: BlocBuilder<PropertyUsersBloc, PropertyUsersState>(
            builder: (context, state) {
              // Log para diagnóstico
              print('Current State: $state');

              if (state is PropertyUsersInitial) {
                return Center(
                    child: Text('Toque no botão para carregar usuários.'));
              } else if (state is PropertyUsersLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is PropertyUsersLoaded) {
                if (state.users.isEmpty) {
                  return Center(child: Text('Nenhum usuário encontrado.'));
                }
                return ListView(
                  children: state.users
                      .map((usuario) => UsuarioListItem(usuario: usuario))
                      .toList(),
                );
              } else if (state is PropertyUsersError) {
                return Center(child: Text('Erro: ${state.message}'));
              }
              // Adicionado estado inicial para diagnóstico
              return Center(child: Text('Estado desconhecido.'));
            },
          )),
    );
  }
}
