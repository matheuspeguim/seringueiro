// sangria_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/utilidade_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/activity_point.dart';
import 'package:flutter_seringueiro/models/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/flutter_kotlin_communication.dart';
import 'package:flutter_seringueiro/views/main/home/property/field_activity/field_activity.dart';
import 'package:flutter_seringueiro/services/storage_service/local_storage_service.dart';
import 'package:flutter_seringueiro/services/open_weather_api_service.dart';

// CLASSE RESPONSÁVEL POR GERENCIAR A ATIVIDADE DE SANGRIA.

class FieldActivityManager {
  bool _isFieldActivityStarted = false;
  FieldActivity? currentFieldActivity;
  Property? currentProperty;

  bool get isActivityStarted => _isFieldActivityStarted;
// Adicionando um callback para atualizar a UI quando o estado muda
  Function(bool)? onFieldActivityStateChanged;

  FieldActivityManager({this.onFieldActivityStateChanged});

  void toggleActivity(
      BuildContext context, User user, Property property) async {
    _isFieldActivityStarted = !_isFieldActivityStarted;
    onFieldActivityStateChanged
        ?.call(_isFieldActivityStarted); // Chamando o callback

    if (_isFieldActivityStarted) {
      String? tabelaSelecionada = await _escolherTabela(context);
      if (tabelaSelecionada != null) {
        currentFieldActivity = await startFieldActivity(
            context, property, user, tabelaSelecionada);
        if (currentFieldActivity == null) {
          _isFieldActivityStarted = false;
          onFieldActivityStateChanged?.call(_isFieldActivityStarted);
          return;
        }
      } else {
        _isFieldActivityStarted = false;
        onFieldActivityStateChanged?.call(_isFieldActivityStarted);
      }
    } else {
      if (currentFieldActivity != null) {
        await finalizarSangria(currentFieldActivity!);
        currentFieldActivity = null;
      }
    }
  }

  Future<String?> _escolherTabela(BuildContext context) async {
    String? tabelaSelecionada;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleciona a tabela de sangria'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                for (var i = 1; i <= 5; i++)
                  ListTile(
                    title: Text('Tabela $i'),
                    onTap: () {
                      tabelaSelecionada = 'Tabela $i';
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );

    return tabelaSelecionada;
  }

  Future<FieldActivity?> startFieldActivity(BuildContext context,
      Property property, User user, String tabelaSelecionada) async {
    if (!await UtilidadeService.verificarEObterPermissaoLocalizacao(context)) {
      return null;
    }

    var condicoesClimaticas =
        await _obterCondicoesClimaticas(property.localizacao);

    return _createFieldActivity(
        property, user, tabelaSelecionada, condicoesClimaticas);
  }

  Future<FieldActivity> _createFieldActivity(
      Property property,
      User user,
      String tabelaSelecionada,
      Map<String, dynamic> condicoesClimaticas) async {
    var fieldActivity = FieldActivity(
      id: FieldActivity.gerarUuid(),
      momento: DateTime.now(),
      duracaoTotal: Duration.zero,
      tabela: tabelaSelecionada,
      usuarioId: user.uid,
      propertyId: property.id,
      condicoesClimaticas: condicoesClimaticas,
      finalizada: false,
      activityPoints: [],
    );

    // Salva a sangria vazia localmente
    await LocalStorageService().saveFieldActivity(fieldActivity);

    // Solicita ao Kotlin para iniciar o registro de pontos
    await FlutterKotlinCommunication.IniciarRegistroPontos(fieldActivity.id);

    return fieldActivity;
  }

  Future<void> finalizarSangria(FieldActivity fieldActivity) async {
    //finaliza o timer da sangria
    fieldActivity.duracaoTotal =
        DateTime.now().difference(fieldActivity.momento);

    //recupera os pontos de sangria salvos no lado kotlin
    await _recuperarPontosDeSangria(fieldActivity);

    // Marcar a sangria como finalizada
    fieldActivity.finalizada = true;

    //sava a sangria no hive
    await LocalStorageService().saveFieldActivity(fieldActivity);

    //tenta sincronizar se possível
    await LocalStorageService().verificarConexaoESincronizarSeNecessario();
  }

  Future<void> _recuperarPontosDeSangria(FieldActivity fieldActivity) async {
    try {
      final pontosMapList =
          await FlutterKotlinCommunication.finalizarRegistroPontos(
              fieldActivity.id);
      if (pontosMapList != null) {
        final activityPoints = pontosMapList
            .map<ActivityPoint>(
                (map) => ActivityPoint.fromMap(map as Map<String, dynamic>))
            .toList();
        activityPoints.addAll(activityPoints);
      }
    } catch (e) {
      print("Erro ao recuperar ActitivitiesPoint: $e");
    }
  }

  Future<Map<String, dynamic>> _obterCondicoesClimaticas(
      GeoPoint localizacao) async {
    WeatherApiService weatherService =
        WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
    try {
      return await weatherService.weatherToFieldActivity(
          localizacao.latitude, localizacao.longitude);
    } catch (e) {
      return {/* Dados climáticos padrão ou vazios */};
    }
  }
}
