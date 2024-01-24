import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/users/property_users_page.dart';
import 'package:flutter_seringueiro/widgets/custom_button.dart';

class AdminWidgets {
  static List<Widget> buildAdminWidgets(
      BuildContext context, Property property) {
    List<Widget> widgets = [];

    // Adicionar todos os widgets relacionados ao administrador
    widgets.add(buildUsersManager(context, property));
    widgets.add(buildDeleteButton(context, property));

    // Adicionar mais widgets conforme necessário

    return widgets;
  }

  static Widget buildUsersManager(context, property) {
    return CustomButton(
      label: 'Gerenciar',
      icon: Icons.add,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PropertyUsersPage(propertyId: property.id),
          ),
        );
      },
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
