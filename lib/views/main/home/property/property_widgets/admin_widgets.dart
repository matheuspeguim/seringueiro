import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class AdminWidgets {
  static Widget buildDeleteButton(BuildContext context, Property property) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return TextButton(
      onPressed: () async {
        final confirmDelete = await showDialog<bool>(
          context: context,
          builder: (dialogContext) {
            return AlertDialog(
              title: Text('Confirmar Exclusão'),
              content: Text(
                  'Deseja realmente excluir a propriedade ${property.nomeDaPropriedade.toUpperCase()}?'),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                ),
                ElevatedButton(
                  child: Text('Excluir', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                ),
              ],
            );
          },
        );

        if (confirmDelete == true) {
          try {
            await firestore.collection('properties').doc(property.id).delete();
            // Adicionar lógica adicional após a exclusão bem-sucedida, se necessário
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro ao excluir propriedade: $e')),
            );
          }
        }
      },
      child: Text('Excluir Propriedade', style: TextStyle(color: Colors.red)),
    );
  }

  // Outros métodos ...
}
