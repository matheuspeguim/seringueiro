import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/new_property/new_property_page.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_bloc.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_event.dart';
import 'package:flutter_seringueiro/views/main/home/property/property_page.dart';

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
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
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
                    Autocomplete<PropriedadeSugestao>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return const Iterable<PropriedadeSugestao>.empty();
                        }
                        return _buscarSugestoes(textEditingValue.text);
                      },
                      optionsViewBuilder: (context, onSelected, options) {
                        return Align(
                          alignment: Alignment.topLeft,
                          child: Material(
                            child: Container(
                              width: 300,
                              height: 200,
                              child: ListView.builder(
                                itemCount: options.length,
                                itemBuilder: (context, index) {
                                  final option = options.elementAt(index);

                                  return ListTile(
                                    title: Text(
                                      'Propriedade: ${option.nome}',
                                      style: TextStyle(fontSize: 18.0),
                                    ),
                                    subtitle: Text(
                                        'Administrador: ${option.adminName}'),
                                    onTap: () {
                                      onSelected(option);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                      onSelected: (PropriedadeSugestao selecao) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => PropertyBloc()
                                ..add(LoadPropertyDetails(
                                    widget.user, selecao.propertyId)),
                              child: PropertyPage(
                                  user: widget.user,
                                  propertyId: selecao.propertyId),
                            ),
                          ),
                        );
                      },
                      fieldViewBuilder:
                          (context, controller, focusNode, onEditingComplete) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          onEditingComplete: onEditingComplete,
                          decoration: InputDecoration(
                            labelText: 'Buscar Propriedade',
                            labelStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) {
                              return BlocProvider<NewPropertyBloc>(
                                create: (context) => NewPropertyBloc(),
                                child: NewPropertyPage(user: widget.user),
                              );
                            }),
                          );
                        },
                        child: Text('Criar uma nova propriedade'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                        ),
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
