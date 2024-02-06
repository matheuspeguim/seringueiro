import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/user/account_management_page.dart';
import 'package:flutter_seringueiro/views/user/profile_page.dart';

class Usuario {
  final String cpf;
  final DateTime dataDeNascimento;
  final String idPersonalizado;
  final String nome;
  final String profilePictureUrl;
  final String rg;

  Usuario({
    required this.cpf,
    required this.dataDeNascimento,
    required this.idPersonalizado,
    required this.nome,
    required this.profilePictureUrl,
    required this.rg,
  });

  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      cpf: data['cpf'],
      dataDeNascimento: DateTime.parse(data['dataDeNascimento']),
      idPersonalizado: data['idPersonalizado'],
      nome: data['nome'],
      profilePictureUrl: data['profilePictureUrl'],
      rg: data['rg'],
    );
  }

  factory Usuario.fromFirebaseUser(
      User user, Map<String, dynamic> firestoreData) {
    return Usuario(
      cpf: firestoreData['cpf'],
      dataDeNascimento: DateTime.parse(firestoreData['dataDeNascimento']),
      idPersonalizado: firestoreData['idPersonalizado'],
      nome: firestoreData['nome'],
      profilePictureUrl: firestoreData['profilePictureUrl'],
      rg: firestoreData['rg'],
    );
  }
}

class UsuarioListItem extends StatelessWidget {
  final Usuario usuario;

  // A chave deve ser marcada como opcional e inicializada com `null` se não for fornecida.
  UsuarioListItem({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // Garantir que o URL da imagem de perfil não seja nulo. Caso contrário, fornecer um placeholder.
        backgroundImage: NetworkImage(usuario.profilePictureUrl.isNotEmpty
            ? usuario.profilePictureUrl
            : 'URL_DE_IMAGEM_PADRÃO'),
      ),
      title: Text(
        usuario.nome,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      // Substitua 'usuario.funcao' pelo campo correto do seu modelo de usuário, se necessário.
      subtitle: Text(usuario.idPersonalizado),
      onTap: () {
        // Navegue para a página de perfil do usuário.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(usuario: usuario),
          ),
        );
      },
    );
  }
}

class UsuarioIcon extends StatelessWidget {
  final Usuario usuario;

  UsuarioIcon({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilePage(usuario: usuario),
          ),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              usuario.profilePictureUrl.isNotEmpty
                  ? usuario.profilePictureUrl
                  : 'URL_DE_IMAGEM_PADRÃO', // Substitua com um URL de imagem padrão
            ),
          ),
          SizedBox(height: 8),
          Text(
            usuario.nome.split(' ').first, // Exibe apenas o primeiro nome
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class UsuarioDrawerHeader extends StatelessWidget {
  final Usuario usuario;

  UsuarioDrawerHeader({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        child: Row(children: <Widget>[
      CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(
          usuario.profilePictureUrl.isNotEmpty
              ? usuario.profilePictureUrl
              : 'URL_DE_IMAGEM_PADRÃO',
        ),
      ),
      SizedBox(
        width: 8,
      ),
      Text(
        usuario.nome,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]));
  }
}
