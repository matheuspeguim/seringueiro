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
  final String cidade;
  final String bairro;
  final String estado;
  final String logradouro;
  final String numero;
  final String cep;

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
    required this.bairro,
    required this.cep,
    required this.cidade,
    required this.estado,
    required this.logradouro,
    required this.numero,
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
        bairro: data['bairro'],
        cep: data['cep'],
        cidade: data['cidade'],
        estado: data['estado'],
        logradouro: data['logradouro'],
        numero: data['numero']);
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
        bairro: firestoreData['bairro'],
        cep: firestoreData['cep'],
        cidade: firestoreData['cidade'],
        estado: firestoreData['estado'],
        logradouro: firestoreData['logradouro'],
        numero: firestoreData['numero']);
  }
}

class UsuarioListItem extends StatelessWidget {
  final Usuario usuario;
  final String? propertyId;

  UsuarioListItem({Key? key, required this.usuario, this.propertyId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(usuario.profilePictureUrl),
      ),
      title: Text(
        usuario.nome,
      ),
      subtitle: Row(children: [
        Text('${usuario.idPersonalizado} | '),
        Text(usuario.cidade)
      ]),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfilePage(usuario: usuario, propertyId: propertyId),
          ),
        );
      },
    );
  }
}

class UsuarioIcon extends StatelessWidget {
  final String usuarioUid;
  final bool exibirNome; // Adiciona o parâmetro booleano

  UsuarioIcon({
    Key? key,
    required this.usuarioUid,
    this.exibirNome = false, // Valor padrão é false, não exibir o nome
  }) : super(key: key);

  Future<Usuario?> getUsuario(String uid) async {
    DocumentSnapshot usuarioSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (usuarioSnapshot.exists) {
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
          return SizedBox(
            width: 24,
            height: 24,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
          );
        }

        if (snapshot.hasError) {
          return Text(
            '!',
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Icon(Icons.account_circle, size: 24);
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
          child: exibirNome
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(usuario.profilePictureUrl),
                    ),
                    SizedBox(height: 4),
                    Text(
                      usuario.nome.split(" ").first,
                    ), // Exibe o nome do usuário
                  ],
                )
              : CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(usuario.profilePictureUrl),
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
        ),
      ])),
    );
  }
}
