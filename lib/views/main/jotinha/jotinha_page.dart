import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class JotinhaPage extends StatefulWidget {
  final User user;

  JotinhaPage({Key? key, required this.user}) : super(key: key);

  @override
  _JotinhaPageState createState() => _JotinhaPageState();
}

class _JotinhaPageState extends State<JotinhaPage> {
  // Aqui, você pode adicionar variáveis de estado e lógica, se necessário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade200,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Aqui você pode adicionar os widgets para exibir as notícias
            // Exemplo de como uma notícia pode ser exibida
            Card(
              child: ListTile(
                leading: Icon(Icons.newspaper),
                title: Text('Título da Notícia'),
                subtitle: Text('Breve descrição da notícia...'),
                onTap: () {
                  // Aqui você pode adicionar a lógica para abrir a notícia completa
                },
              ),
            ),
            // Adicione mais cards para outras notícias
          ],
        ),
      ),
      // Você pode adicionar um FAB ou outros widgets conforme necessário
    );
  }
}
