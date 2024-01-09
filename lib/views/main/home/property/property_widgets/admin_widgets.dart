import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';

class AdminWidgets {
  static List<Widget> buildAdminWidgets(
      BuildContext context, Property property) {
    return [
      Divider(),
      Align(
        alignment: Alignment(-0.85, -1.00), // Define o alinhamento à esquerda
        child: Text(
          'Administrador',
          style: TextStyle(fontSize: 12.0, color: Colors.green),
        ),
      ),
      buildUsersPainel(property),
      SizedBox(height: 8),
      buildDeleteButton(context, property),
    ];
  }

  static Widget buildUsersPainel(Property property) {
    return SingleChildScrollView(
      child: Card(
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Colors.green.shade100,
        margin: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              child: Text(
                "Usuários",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Corpo
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  // Adicione mais Widgets aqui para exibir os detalhes da propriedade
                ],
              ),
            ),

            // Rodapé (se necessário, adicione funcionalidades similares ao _buildPropertyCard)
          ],
        ),
      ),
    );
  }

  static Widget buildDeleteButton(BuildContext context, Property property) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Center(
      child: TextButton(
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
                    child:
                        Text('Excluir', style: TextStyle(color: Colors.white)),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                  ),
                ],
              );
            },
          );

          if (confirmDelete == true) {
            try {
              await firestore
                  .collection('properties')
                  .doc(property.id)
                  .delete();
              // Navegar de volta após a exclusão bem-sucedida
              Navigator.of(context).pop(); // Volta para a tela anterior
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Erro ao excluir propriedade: $e')),
              );
            }
          }
        },
        child: Text('Excluir Propriedade', style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
