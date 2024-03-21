import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_bloc.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_event.dart';
import 'package:flutter_seringueiro/views/main/seachers/user_seacher/user_seacher_state.dart';

class UserSearchPage extends StatefulWidget {
  final String? propertyId;

  const UserSearchPage({Key? key, this.propertyId}) : super(key: key);

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context
        .read<UserSearchBloc>()
        .add(UserSearchQueryChanged(_searchController.text));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar usuário',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged(); // Garante que a busca seja resetada
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserSearchBloc, UserSearchState>(
              builder: (context, state) {
                if (state is UserSearchLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is UserSearchSuccess) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      return UsuarioListItem(usuario: state.users[index]);
                    },
                  );
                } else if (state is UserSearchError) {
                  return Center(child: Text(state.message));
                } else if (state is UserSearchEmpty) {
                  // Exibir uma mensagem padrão ou nada
                  return Center(
                      child: Text('Digite o ID personalizado para buscar.'));
                }
                return Container(); // Quando o estado inicial ou se não quiser mostrar nada inicialmente
              },
            ),
          ),
        ],
      ),
    );
  }
}
