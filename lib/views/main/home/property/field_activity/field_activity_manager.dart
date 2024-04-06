import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_seringueiro/common/models/property.dart';
import 'package:flutter_seringueiro/common/services/utilidade_service.dart';
import 'package:flutter_seringueiro/common/models/field_activity.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/fiel_activity_services.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/flutter_kotlin_communication.dart';

class FieldActivityManager {
  FieldActivity? fieldActivity;
  Property? currentProperty;

  // Callback para atualização da UI, se necessário
  Function(FieldActivity?)? onActivityUpdate;

  FieldActivityManager({this.onActivityUpdate});

  Future<void> iniciarAtividade(BuildContext context, User user,
      Property property, String atividade) async {
    // Verifica se já existe uma atividade em andamento
    bool atividadeEmAndamento =
        await FieldActivityServices.verificaAtividadeEmAndamento(
            user.uid, property.id);
    if (atividadeEmAndamento) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Já existe uma atividade em andamento.')),
      );
      return;
    }

    //Verifica permissões de localização
    if (!await UtilidadeService.verificarEObterPermissaoLocalizacao(context)) {
      return;
    }

    // Seleciona a tabela
    var tabelaSelecionada =
        await FieldActivityServices.selecionarTabela(context);
    if (tabelaSelecionada == null) {
      return;
    }

    // Obtém condições climáticas

    // Cria a atividade
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('field_activities').doc();

    FieldActivity activity = FieldActivity(
      id: docRef.id,
      inicio: DateTime.now(),
      fim: DateTime
          .now(), // Este valor será atualizado quando a atividade for finalizada
      tabela: tabelaSelecionada,
      atividade: atividade,
      usuarioUid: user.uid,
      propertyId: property.id,
      finalizada: false,
    );

    // Salva a nova atividade no Firestore
    await docRef.set(activity.toMap(), SetOptions(merge: true));

    // Inicia o rastreamento de pontos de atividade no lado Kotlin
    FlutterKotlinCommunication.startActivityPointsTracker(activity);

    // Atualiza a UI se necessário
    if (onActivityUpdate != null) {
      onActivityUpdate!(activity);
    }
  }

  Future<void> cancelarAtividade(
      BuildContext context, FieldActivity activity) async {
    // Comunica com o Kotlin para cancelar o rastreamento dos pontos de atividade
    await FlutterKotlinCommunication.finishActivityPointsTracker(activity);

    // Exclui o documento da atividade no Firestore
    await FirebaseFirestore.instance
        .collection('field_activities')
        .doc(activity.id)
        .delete();

// Primeiro, obtenha uma referência à coleção
    var collectionRef =
        FirebaseFirestore.instance.collection('activity_points');

// Realize a consulta para encontrar os documentos
    var querySnapshot =
        await collectionRef.where('activityId', isEqualTo: activity.id).get();

// Itere sobre os documentos encontrados e exclua cada um
    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    // Mostra um Snackbar (ou outro feedback) informando que a atividade foi cancelada e excluída
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Atividade ${activity.atividade} foi cancelada')),
    );

    // Adicione aqui qualquer lógica adicional após o cancelamento e exclusão da atividade,
    // como navegar de volta para a tela anterior ou atualizar a UI.
  }

  Future<void> finalizarAtividade(context, activity) async {
    FlutterKotlinCommunication.finishActivityPointsTracker(activity);

    // Atualiza o documento da atividade no Firestore, definindo finalizada como true
    await FirebaseFirestore.instance
        .collection('field_activities')
        .doc(activity.id)
        .update({'finalizada': true, 'fim': DateTime.now()});

    // Mostra um Snackbar (ou outro feedback) informando que a atividade foi cancelada e excluída
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Atividade ${activity.atividade} foi finalizada')),
    );

    // Aqui, você pode adicionar qualquer lógica adicional necessária após a finalização da atividade,
    // como navegar para outra tela ou exibir uma mensagem de sucesso.
  }
}
