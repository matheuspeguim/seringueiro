import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/services/utilidade_service.dart';
import 'package:flutter_seringueiro/models/field_activity.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/flutter_kotlin_communication.dart';

class FieldActivityManager {
  FieldActivity? currentFieldActivity;
  Property? currentProperty;

  // Callback para atualização da UI, se necessário
  Function(FieldActivity?)? onActivityUpdate;

  FieldActivityManager({this.onActivityUpdate});

  Future<void> iniciarAtividade(BuildContext context, User user,
      Property property, String atividade) async {
    // Verifica se já existe uma atividade em andamento no Firestore
    bool atividadeEmAndamento =
        await verificaAtividadeEmAndamento(user.uid, property.id);
    if (atividadeEmAndamento) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Já existe uma atividade em andamento.')),
      );
      return;
    }

    if (!await UtilidadeService.verificarEObterPermissaoLocalizacao(context)) {
      return;
    }

    var tabelaSelecionada = await _selecionarTabela(context);
    if (tabelaSelecionada == null) {
      return;
    }

    var condicoesClimaticas =
        await _obterCondicoesClimaticas(property.localizacao);

    DocumentReference docRef = FirebaseFirestore.instance
        .collection('properties')
        .doc(property.id)
        .collection('field_activities')
        .doc();

    currentFieldActivity = FieldActivity(
      inicio: DateTime.now(),
      fim: DateTime.now(), // Será atualizado ao finalizar
      tabela: tabelaSelecionada,
      atividade: atividade,
      usuarioUid: user.uid,
      propertyId: property.id,
      condicoesClimaticas: condicoesClimaticas,
      finalizada: false,
      activityPoints: [],
    );

    await docRef.set(currentFieldActivity!.toMap(), SetOptions(merge: true));
    currentFieldActivity!.id = docRef
        .id; // Atualiza o ID da FieldActivity com o ID gerado pelo Firestore

    FlutterKotlinCommunication.startActivityPointsTracker(docRef.id);
    onActivityUpdate?.call(currentFieldActivity);
  }

  Future<void> cancelarAtividade() async {}

  Future<void> finalizarAtividade(context, activity) async {
    // Exibe um AlertDialog para confirmar a finalização
    bool confirmado = await _confirmarFinalizacao(context);
    if (confirmado) {
      // Aqui vai a chamada para o método Kotlin para finalizar o registro dos activitypoints
      FlutterKotlinCommunication.finishActivityPointsTracker(activity.id);

      // Atualiza o documento da atividade no Firestore, definindo finalizada como true
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(activity.propertyId)
          .collection('field_activities')
          .doc(activity.id)
          .update({'finalizada': true});

      // Aqui, você pode adicionar qualquer lógica adicional necessária após a finalização da atividade,
      // como navegar para outra tela ou exibir uma mensagem de sucesso.
    }
  }

  Future<bool> _confirmarFinalizacao(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar Finalização'),
              content:
                  Text('Você tem certeza que deseja finalizar esta atividade?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Confirmar'),
                ),
              ],
            );
          },
        ) ??
        false; // Retorna false se o usuário fechar o AlertDialog sem escolher
  }

  Future<bool> verificaAtividadeEmAndamento(
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

  Future<String?> _selecionarTabela(BuildContext context) async {
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

  Future<Map<String, dynamic>> _obterCondicoesClimaticas(
      GeoPoint localizacao) async {
    OpenWeatherApiService weatherService =
        OpenWeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
    try {
      return await weatherService.weatherToFieldActivity(
          localizacao.latitude, localizacao.longitude);
    } catch (e) {
      return {/* Dados climáticos padrão ou vazios */};
    }
  }
}
