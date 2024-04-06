import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_page/new_property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/new_property/new_property_page/new_property_page.dart';

class SearchPropertyPage extends StatefulWidget {
  final User user;

  SearchPropertyPage({Key? key, required this.user}) : super(key: key);

  @override
  _SearchPropertyPageState createState() => _SearchPropertyPageState();
}

class PropriedadeSugestao {
  final String nome;
  final String adminName;
  final String propertyId;

  PropriedadeSugestao(
      {required this.nome, required this.adminName, required this.propertyId});
}

class _SearchPropertyPageState extends State<SearchPropertyPage> {
  final _nomeDaPropriedadeController = TextEditingController();

  @override
  void dispose() {
    _nomeDaPropriedadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Adicionar Propriedade',
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return BlocProvider<NewPropertyBloc>(
                                create: (context) => NewPropertyBloc(),
                                child: NewPropertyPage(),
                              );
                            }),
                          );
                        },
                        child: Text('Criar uma nova propriedade'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<PropriedadeSugestao>> _buscarSugestoes(String busca) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String searchTermLower = busca.toLowerCase();
    String searchTermUpper = busca.toLowerCase() + '\uf8ff';

    QuerySnapshot querySnapshot = await firestore
        .collection('properties')
        .where('nomeDaPropriedade', isGreaterThanOrEqualTo: searchTermLower)
        .where('nomeDaPropriedade', isLessThanOrEqualTo: searchTermUpper)
        .get();

    List<PropriedadeSugestao> suggestions = [];

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String adminName = data['adminName'] ??
          'Nome Indisponível'; // Usando o nome do administrador salvo na propriedade

      suggestions.add(PropriedadeSugestao(
        nome: data['nomeDaPropriedade'] ?? '',
        adminName: adminName, // Usando o nome real diretamente
        propertyId: doc.id,
      ));
    }

    return suggestions;
  }
}
