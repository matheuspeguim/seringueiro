import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/user/profile_page/profile_page.dart';

class Usuario {
  final String email;
  final String celular;
  final String cpf;
  final DateTime nascimento;
  final String idPersonalizado;
  final String nome;
  final String profilePictureUrl; // Agora é uma String não nula
  final String rg;

  // URL da imagem padrão
  static const String _defaultProfilePictureUrl =
      'https://firebasestorage.googleapis.com/v0/b/seringueiroapp.appspot.com/o/profilePictures%2Fvecteezy_illustration-of-human-icon-vector-user-symbol-icon-modern_8442086.jpg?alt=media&token=cdadba3c-68db-4d1b-ace3-b18d7b4733a2';

  Usuario({
    required this.email,
    required this.celular,
    required this.cpf,
    required this.nascimento,
    required this.idPersonalizado,
    required this.nome,
    String? profilePictureUrl,
    required this.rg,
  }) : this.profilePictureUrl = profilePictureUrl ?? _defaultProfilePictureUrl;

  factory Usuario.fromMap(Map<String, dynamic> data) {
    return Usuario(
      email: data['email'],
      celular: data['celular'],
      cpf: data['cpf'],
      nascimento: (data['nascimento'] as Timestamp)
          .toDate(), // Convertendo de Timestamp para DateTime
      idPersonalizado: data['idPersonalizado'],
      nome: data['nome'],
      profilePictureUrl: data['profilePictureUrl'],
      rg: data['rg'],
    );
  }

  factory Usuario.fromFirebaseUser(
      User user, Map<String, dynamic> firestoreData) {
    return Usuario(
      email: firestoreData['email'],
      celular: firestoreData['celular'],
      cpf: firestoreData['cpf'],
      nascimento:
          (firestoreData['nascimento'] as Timestamp).toDate(), // Ajuste aqui
      idPersonalizado: firestoreData['idPersonalizado'],
      nome: firestoreData['nome'],
      profilePictureUrl: firestoreData['profilePictureUrl'],
      rg: firestoreData['rg'],
    );
  }
}

class UsuarioListItem extends StatelessWidget {
  final Usuario usuario;

  UsuarioListItem({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(usuario.profilePictureUrl),
      ),
      title: Text(
        usuario.nome,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(usuario.idPersonalizado),
      onTap: () {
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
  final String usuarioUid;
  UsuarioIcon({Key? key, required this.usuarioUid}) : super(key: key);

  Future<Usuario?> getUsuario(String uid) async {
    // Supondo que você tenha uma função que retorna o usuário dado o UID.
    // Adapte para sua estrutura de dados e coleção.
    DocumentSnapshot usuarioSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (usuarioSnapshot.exists) {
      // Supondo que você tenha um método fromMap para a classe Usuario.
      return Usuario.fromMap(usuarioSnapshot.data() as Map<String, dynamic>);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Usuario?>(
      future: getUsuario(usuarioUid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar usuário.'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('Usuário não encontrado.'));
        }

        Usuario usuario = snapshot.data!;
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
                backgroundImage: NetworkImage(usuario.profilePictureUrl),
              ),
              SizedBox(height: 8),
              Text(
                usuario.nome.split(' ').first, // Exibe apenas o primeiro nome
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        );
      },
    );
  }
}

class UsuarioDrawerHeader extends StatelessWidget {
  final Usuario usuario;
  UsuarioDrawerHeader({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfilePage(usuario: usuario))),
      child: DrawerHeader(
          child: Row(children: <Widget>[
        CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage(usuario.profilePictureUrl),
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
      ])),
    );
  }
}
