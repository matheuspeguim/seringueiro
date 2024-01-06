import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SeringuiaPage extends StatelessWidget {
  final User user;

  SeringuiaPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seringuia'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Bem-vindo ao Seringuia!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Aqui você encontrará informações e recursos úteis.',
              style: TextStyle(fontSize: 16),
            ),
            // Adicione mais widgets conforme a necessidade
          ],
        ),
      ),
    );
  }
}
