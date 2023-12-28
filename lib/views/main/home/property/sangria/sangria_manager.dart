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
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

// CLASSE RESPONSÁVEL POR GERENCIAR A ATIVIDADE DE SANGRIA.

class SangriaManager {
  final MethodChannel _platform =
      MethodChannel('com.example.flutter_seringueiro/sangria');

  //INICIALIZAÇÃO DE SANGRIA

  Future<Sangria?> iniciarSangria(
      Property property, User user, String tabelaSelecionada) async {
    // Verificar se a permissão de localização foi concedida
    var status = await Permission.location.status;
    if (!status.isGranted) {
      // Solicitar permissão de localização, caso ainda não concedido
      status = await Permission.location.request();
    }

    if (!status.isGranted) {
      print("Permissão de localização não concedida");
      return null;
    }

    // Prosseguir com a iniciação da sangria
    return _criarSangria(property, user, tabelaSelecionada);
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

  Future<Sangria> _criarSangria(
      Property property, User user, String tabelaSelecionada) async {
    // Obter as condições climáticas
    var condicoesClimaticas =
        await _obterCondicoesClimaticas(property.localizacao);

    // Criar o objeto Sangria
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

    await _salvarNovaSangria(sangria);

    await _platform
        .invokeMethod('iniciarRegistroPontos', {'sangriaId': sangria.id});

    return sangria;
  }

  //CONDIÇÕES CLIMÁTICAS PARA RASTREABILIDADE DE UMA SANGRIA
  Future<Map<String, dynamic>> _obterCondicoesClimaticas(
      GeoPoint localizacao) async {
    WeatherApiService weatherService =
        WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
    try {
      return await weatherService.getCurrentWeather(
          localizacao.latitude, localizacao.longitude);
    } catch (e) {
      return {/* Dados climáticos padrão ou vazios */};
    }
  }

  //SALVA A SANGRIA NO ARMAZENAMENTO LOCAL PARA POSTERIOR ALIMENTAÇÃO
  // COM OS PONTOS DE SANGRIA

  Future<void> _salvarNovaSangria(Sangria sangria) async {
    var box = await Hive.openBox<Sangria>('sangrias');
    await box.put(sangria.id, sangria);
    await box.close();
  }

  //FINALIZA A SANGRIA E DÁ O COMANDO PARA FINALIZAR NO LADO KOTLIN
  Future<void> finalizarSangria(Sangria sangria) async {
    //recupera os pontos de sangria salvos no lado kotlin
    await _recuperarPontosDeSangria(sangria);

    //finaliza o timer da sangria
    sangria.duracaoTotal = DateTime.now().difference(sangria.momento);

    // Marcar a sangria como finalizada
    sangria.finalizada = true;

    //sava a sangria no hive
    await _salvarSangria(sangria);

    //tenta sincronizar se possível
    await LocalStorageService().verificarConexaoESincronizarSeNecessario();
  }

  Future<void> _recuperarPontosDeSangria(Sangria sangria) async {
    try {
      final pontosMapList = await _platform
          .invokeMethod('transferirPontosDeSangria', {'sangriaId': sangria.id});
      final pontosDeSangria =
          _convertMapListToPontoDeSangriaList(pontosMapList);
      sangria.pontos.addAll(pontosDeSangria);
    } catch (e) {
      print("Erro ao recuperar pontos de sangria: $e");
    }
  }

  Future<void> _salvarSangria(Sangria sangria) async {
    await LocalStorageService().saveSangria(sangria);
  }

  List<PontoDeSangria> _convertMapListToPontoDeSangriaList(
      List<dynamic> mapList) {
    return mapList
        .map((map) => PontoDeSangria.fromMap(map as Map<String, dynamic>))
        .toList();
  }

  Future<void> cancelarSangria(Sangria sangria) async {
    // Aqui você pode adicionar lógica para redefinir o estado do Flutter
    // Por exemplo, limpar variáveis, fechar caixas de diálogo, etc.

    // Comunicar com o Kotlin para parar qualquer processo de sangria
    try {
      await _platform.invokeMethod('pararRegistroPontos');
      await _removerSangriaLocal(sangria);
    } catch (e) {
      print("Erro ao parar a sangria no lado do Kotlin: $e");
    }

    // Redefinir o estado do aplicativo para o inicial
    // Por exemplo, definir variáveis para seus valores padrão
  }

  Future<void> _removerSangriaLocal(Sangria sangria) async {
    await LocalStorageService().deleteSangria(sangria.id);
  }
}
