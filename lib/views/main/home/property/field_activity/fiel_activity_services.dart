import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FieldActivityServices {
  // Verifica se existe alguma atividade em andamento para um usuário e propriedade específicos
  static Future<bool> verificaAtividadeEmAndamento(
      String userId, String propertyId) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyId)
        .collection('field_activities')
        .where('usuarioUid', isEqualTo: userId)
        .where('finalizada', isEqualTo: false)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // Exibe um diálogo para o usuário selecionar uma tabela dentre as opções disponíveis
  static Future<String?> selecionarTabela(BuildContext context) async {
    String? tabelaSelecionada;

    // Opções de tabelas disponíveis
    final List<String> tabelas = [
      'Tabela 1',
      'Tabela 2',
      'Tabela 3',
      'Tabela 4',
      'Tabela 5'
    ];

    // Exibe o AlertDialog
    final bool? confirmado = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        String? escolhaTemporaria;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Selecione a Tabela'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: tabelas
                    .map((tabela) => RadioListTile<String>(
                          title: Text(tabela),
                          value: tabela,
                          groupValue: escolhaTemporaria,
                          onChanged: (value) {
                            setState(() => escolhaTemporaria = value);
                          },
                        ))
                    .toList(),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: Text('Confirmar'),
                  onPressed: () {
                    tabelaSelecionada = escolhaTemporaria;
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    return confirmado == true ? tabelaSelecionada : null;
  }
}
