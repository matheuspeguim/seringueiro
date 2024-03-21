import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertySelectionPage extends StatefulWidget {
  const PropertySelectionPage({Key? key}) : super(key: key);

  @override
  _PropertySelectionPageState createState() => _PropertySelectionPageState();
}

class _PropertySelectionPageState extends State<PropertySelectionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> _loadUserProperties() {
    // Obtenha o ID do usuário atual
    final userId = _auth.currentUser?.uid;

    // Crie uma stream de propriedades onde o usuário é administrador
    return _firestore
        .collection('properties')
        .where('admins', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecione uma Propriedade')),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _loadUserProperties(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma propriedade encontrada.'));
          }

          final properties = snapshot.data!;

          return ListView.builder(
            itemCount: properties.length,
            itemBuilder: (context, index) {
              final property = properties[index];
              return ListTile(
                title: Text(property[
                    'name']), // Supondo que cada propriedade tem um campo 'name'
                onTap: () {
                  Navigator.pop(
                      context,
                      property[
                          'id']); // Supondo que cada propriedade tem um campo 'id'
                },
              );
            },
          );
        },
      ),
    );
  }
}
