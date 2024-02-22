import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';
import 'package:flutter_seringueiro/services/storage_service/local_storage_service.dart';
import 'package:flutter_seringueiro/services/utilidade_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/activity_point.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/flutter_kotlin_communication.dart';

class FieldActivityManager {
  FieldActivity? currentFieldActivity;
  Property? currentProperty;

  // Callback para atualização da UI, se necessário
  Function(FieldActivity?)? onActivityUpdate;

  FieldActivityManager({this.onActivityUpdate});

  bool get isActivityStarted =>
      currentFieldActivity != null &&
      currentFieldActivity!.fim.isAfter(DateTime.now());

  Future<void> iniciarAtividade(BuildContext context, User user,
      Property property, String atividade) async {
    if (isActivityStarted) {
      return; // Já existe uma atividade em andamento
    }

    // Verificar e obter permissões de localização
    if (!await UtilidadeService.verificarEObterPermissaoLocalizacao(context)) {
      return;
    }

    // Obter condições climáticas
    var condicoesClimaticas =
        await _obterCondicoesClimaticas(property.localizacao);

    // Criar a FieldActivity
    currentFieldActivity = FieldActivity(
      id: FieldActivity.gerarUuid(),
      inicio: DateTime.now(),
      fim: DateTime.now().add(Duration(
          hours:
              1)), // Define um tempo de fim padrão que será atualizado ao finalizar
      tabela: "Tabela_Padrão", // Isso deve ser configurado adequadamente
      atividade: atividade,
      usuarioUid: user.uid,
      propertyId: property.id,
      condicoesClimaticas: condicoesClimaticas,
      finalizada: false,
      activityPoints: [],
    );

    // Salvar a atividade inicial no armazenamento local
    await LocalStorageService().saveFieldActivity(currentFieldActivity!);

    // Iniciar o registro de pontos no lado do Kotlin
    FlutterKotlinCommunication.iniciarRegistroPontos(currentFieldActivity!.id);

    // Atualizar a UI
    onActivityUpdate?.call(currentFieldActivity);
  }

  Future<void> finalizarAtividade() async {
    if (!isActivityStarted || currentFieldActivity == null) {
      return; // Não há atividade em andamento para finalizar
    }

    // Finalizar o registro de pontos no lado do Kotlin e recuperar pontos
    var pontosMapList =
        await FlutterKotlinCommunication.finalizarRegistroPontos(
            currentFieldActivity!.id);

// Verifica se a lista recebida não é nula antes de tentar mapeá-la.
    if (pontosMapList != null) {
      var pontos = pontosMapList
          .map<ActivityPoint>(
              (ponto) => ActivityPoint.fromMap(ponto as Map<String, dynamic>))
          .toList();
      currentFieldActivity!.activityPoints.addAll(pontos);
    } else {
      // Handle the case where pontosMapList is null if necessary
      print("Nenhum ponto de atividade foi retornado.");
    }

    // Atualizar o estado da atividade para finalizada
    currentFieldActivity!.fim = DateTime.now();
    currentFieldActivity!.finalizada = true;

    // Salvar a atividade finalizada no armazenamento local
    await LocalStorageService().saveFieldActivity(currentFieldActivity!);

    // Atualizar a UI
    onActivityUpdate?.call(currentFieldActivity);

    // Limpar a atividade atual
    currentFieldActivity = null;
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
