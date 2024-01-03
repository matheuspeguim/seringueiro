// sangria_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

// CLASSE RESPONSÁVEL POR GERENCIAR A ATIVIDADE DE SANGRIA.

class SangriaManager {
  final MethodChannel _platform =
      const MethodChannel('com.example.flutter_seringueiro/sangria');

  Future<Sangria?> iniciarSangria(
      Property property, User user, String tabelaSelecionada) async {
    if (!await _verificarEObterPermissaoLocalizacao()) {
      return null;
    }

    var condicoesClimaticas =
        await _obterCondicoesClimaticas(property.localizacao);

    return _criarSangria(
        property, user, tabelaSelecionada, condicoesClimaticas);
  }

  Future<Sangria> _criarSangria(
      Property property,
      User user,
      String tabelaSelecionada,
      Map<String, dynamic> condicoesClimaticas) async {
    var sangria = Sangria(
      id: Sangria.gerarUuid(),
      momento: DateTime.now(),
      duracaoTotal: Duration.zero,
      tabela: tabelaSelecionada,
      usuarioId: user.uid,
      propertyId: property.id,
      condicoesClimaticas: condicoesClimaticas,
      finalizada: false,
      pontos: [],
    );

    //Salva a sangria vazia localmente
    await LocalStorageService().saveSangria(sangria);

    //Solicita ao kotlin para iniciar o registro de pontos
    await _platform
        .invokeMethod('iniciarRegistroPontos', {'sangriaId': sangria.id});

    return sangria;
  }

  Future<void> finalizarSangria(Sangria sangria) async {
    //finaliza o timer da sangria
    sangria.duracaoTotal = DateTime.now().difference(sangria.momento);

    //recupera os pontos de sangria salvos no lado kotlin
    await _recuperarPontosDeSangria(sangria);

    // Marcar a sangria como finalizada
    sangria.finalizada = true;

    //sava a sangria no hive
    await LocalStorageService().saveSangria(sangria);

    //tenta sincronizar se possível
    await LocalStorageService().verificarConexaoESincronizarSeNecessario();
  }

  Future<void> _recuperarPontosDeSangria(Sangria sangria) async {
    try {
      final pontosMapList = await _platform
          .invokeMethod('finalizarRegistroPontos', {'sangriaId': sangria.id});
      if (pontosMapList != null) {
        final pontosDeSangria = pontosMapList
            .map<PontoDeSangria>(
                (map) => PontoDeSangria.fromMap(map as Map<String, dynamic>))
            .toList();
        sangria.pontos.addAll(pontosDeSangria);
      }
    } catch (e) {
      print("Erro ao recuperar pontos de sangria: $e");
    }
  }

  Future<void> cancelarSangria(Sangria sangria) async {
    // Comunicar com o Kotlin para parar qualquer processo de sangria
    try {
      await _platform.invokeMethod('pararRegistroPontos');

      //Remove a sangria do armazenamento local
      await LocalStorageService().deleteSangria(sangria.id);
    } catch (e) {
      print("Erro ao parar a sangria no lado do Kotlin: $e");
    }
  }

  Future<bool> _verificarEObterPermissaoLocalizacao() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
    return status.isGranted;
  }

  Future<void> mostrarDialogoPermissaoLocalizacao(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // O usuário deve tocar em um botão para fechar o diálogo
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Permissão de Localização Necessária'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'O processo de sangria não pode ser iniciado sem a permissão de localização.'),
                Text(
                    'Por favor, habilite a permissão de localização nas configurações do sistema.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar Sangria'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Fecha o diálogo
                // Adicione aqui qualquer lógica adicional necessária para cancelar a sangria
              },
            ),
            TextButton(
              child: Text('Abrir Configurações'),
              onPressed: () async {
                // Abre as configurações do aplicativo
                var url = Uri.parse('app-settings:');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  throw 'Não foi possível abrir as configurações do aplicativo.';
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> _obterCondicoesClimaticas(
      GeoPoint localizacao) async {
    WeatherApiService weatherService =
        WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
    try {
      return await weatherService.getCurrentWeatherSnapshot(
          localizacao.latitude, localizacao.longitude);
    } catch (e) {
      return {/* Dados climáticos padrão ou vazios */};
    }
  }
}
