import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_seringueiro/common/models/usuario.dart';
import 'package:flutter_seringueiro/common/widgets/custom_button.dart';
import 'package:flutter_seringueiro/common/widgets/property_selection_page.dart';

class AddUserToPropertyWidget extends StatefulWidget {
  final Usuario usuario;
  final String? propertyId;

  const AddUserToPropertyWidget(
      {Key? key, required this.usuario, this.propertyId})
      : super(key: key);

  @override
  State<AddUserToPropertyWidget> createState() =>
      _AddUserToPropertyWidgetState();
}

class _AddUserToPropertyWidgetState extends State<AddUserToPropertyWidget> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addUserToProperty(String propertyId, Map<String, bool> roles) async {
    await _firestore.collection('property_users').add({
      'uid': widget.usuario,
      'propertyId': propertyId,
      'administrador': roles['admin'] ?? false,
      'seringueiro': roles['seringueiro'] ?? false,
      'proprietario': roles['proprietario'] ?? false,
      'agronomo': roles['agronomo'] ?? false,
    });

    Navigator.of(context).pop(); // Fecha o AlertDialog após a confirmação
  }

  void _showRoleSelectionDialog(String propertyId) {
    Map<String, bool> selectedRoles = {
      'seringueiro': false,
      'agronomo': false,
      'proprietario': false,
      'admin': false,
    };

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Selecionar Funções'),
          content: SingleChildScrollView(
            child: ListBody(
              children: selectedRoles.keys.map((role) {
                return CheckboxListTile(
                  title: Text(role),
                  value: selectedRoles[role],
                  onChanged: (bool? value) {
                    setState(() {
                      selectedRoles[role] = value!;
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => _addUserToProperty(propertyId, selectedRoles),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _handleAddUser() async {
    String? propertyId = widget.propertyId;
    if (propertyId == null) {
      propertyId = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const PropertySelectionPage()), // Substitua pelo seu widget/tela real
      );
    }

    if (propertyId != null) {
      _showRoleSelectionDialog(propertyId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      icon: Icons.add,
      label: 'Convidar',
      onPressed: _handleAddUser,
    );
  }
}
