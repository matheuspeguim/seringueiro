// sangria_manager.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/utilidade_service.dart';
import 'package:flutter_seringueiro/views/main/home/property/property.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/flutter_kotlin_communication.dart';
import 'package:flutter_seringueiro/views/main/home/property/sangria/sangria.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';

// CLASSE RESPONSÁVEL POR GERENCIAR A ATIVIDADE DE SANGRIA.

class SangriaManager {
  bool _isSangriaIniciada = false;
  Sangria? sangriaAtual;
  Property? currentProperty;

  bool get isSangriaIniciada => _isSangriaIniciada;
// Adicionando um callback para atualizar a UI quando o estado muda
  Function(bool)? onSangriaStateChanged;

  SangriaManager({this.onSangriaStateChanged});

  final MethodChannel _platform =
      const MethodChannel('com.example.flutter_seringueiro/sangria');

  void toggleSangria(BuildContext context, User user, Property property) async {
    _isSangriaIniciada = !_isSangriaIniciada;
    onSangriaStateChanged?.call(_isSangriaIniciada); // Chamando o callback

    if (_isSangriaIniciada) {
      String? tabelaSelecionada = await _escolherTabela(context);
      if (tabelaSelecionada != null) {
        sangriaAtual =
            await iniciarSangria(context, property, user, tabelaSelecionada);
        if (sangriaAtual == null) {
          _isSangriaIniciada = false;
          onSangriaStateChanged?.call(_isSangriaIniciada);
          return;
        }
      } else {
        _isSangriaIniciada = false;
        onSangriaStateChanged?.call(_isSangriaIniciada);
      }
    } else {
      if (sangriaAtual != null) {
        await finalizarSangria(sangriaAtual!);
        sangriaAtual = null;
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

  Future<Sangria?> iniciarSangria(BuildContext context, Property property,
      User user, String tabelaSelecionada) async {
    if (!await UtilidadeService.verificarEObterPermissaoLocalizacao(context)) {
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

    // Salva a sangria vazia localmente
    await LocalStorageService().saveSangria(sangria);

    // Solicita ao Kotlin para iniciar o registro de pontos
    await FlutterKotlinCommunication.IniciarRegistroPontos(sangria.id);

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
      final pontosMapList =
          await FlutterKotlinCommunication.finalizarRegistroPontos(sangria.id);
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

  Future<Map<String, dynamic>> _obterCondicoesClimaticas(
      GeoPoint localizacao) async {
    WeatherApiService weatherService =
        WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
    try {
      return await weatherService.climaParaSangria(
          localizacao.latitude, localizacao.longitude);
    } catch (e) {
      return {/* Dados climáticos padrão ou vazios */};
    }
  }
}
