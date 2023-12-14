import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_seringueiro/services/local_storage_service.dart';
import 'package:flutter_seringueiro/services/weather_api_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sensors/sensors.dart';
import 'package:vibration/vibration.dart';
import 'dart:math' as math;

class Sangria {
  DateTime momento;
  Duration duracaoTotal;
  String tabela;
  String usuarioId; // Armazenar o ID do usuário como string
  Map<String, dynamic> condicoesClimaticas;
  List<PontoDeSangria> pontos;

  Sangria({
    required this.momento,
    required this.duracaoTotal,
    required this.tabela,
    required this.usuarioId,
    required this.condicoesClimaticas,
    this.pontos = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'momento': Timestamp.fromDate(momento), // Convertendo para Timestamp
      'duracaoTotal': duracaoTotal,
      'tabela': tabela,
      'usuarioId': usuarioId,
      'condicoesClimaticas': condicoesClimaticas,
      'pontos': pontos.map((ponto) => ponto.toMap()).toList(),
    };
  }

  static Sangria fromMap(Map<String, dynamic> map) {
    return Sangria(
      momento:
          (map['momento'] as Timestamp).toDate(), // Convertendo para DateTime
      duracaoTotal: map['duracaoTotal'],
      tabela: map['tabela'],
      usuarioId: map['usuarioId'],
      condicoesClimaticas: map['condicoesClimaticas'],
      pontos: List<PontoDeSangria>.from(
        map['pontos'].map((x) => PontoDeSangria.fromMap(x)),
      ),
    );
  }
}

// Métodos para converter de/para um mapa (para uso com Firestore)

class PontoDeSangria {
  int id;
  DateTime timestamp;
  LatLng localizacao;
  int duracao; // Duração do ponto de sangria

  PontoDeSangria({
    required this.id,
    required this.timestamp,
    required this.localizacao,
    required this.duracao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'timestamp': Timestamp.fromDate(timestamp),
      'localizacao': GeoPoint(localizacao.latitude, localizacao.longitude),
      'duracao': duracao,
    };
  }

  static PontoDeSangria fromMap(Map<String, dynamic> map) {
    GeoPoint geoPoint = map['localizacao'];
    return PontoDeSangria(
      id: map['id'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      localizacao: LatLng(geoPoint.latitude, geoPoint.longitude),
      duracao: map['duracao'],
    );
  }
}

class SangriaService {
  List<PontoDeSangria> pontosDeSangria = [];
  Sangria? sangriaAtual;
  int proximoIdPonto = 0;
  DateTime? inicioPontoAtual;
  DateTime? inicioSangria;
  double umLimiarEspecifico = 10.5;
  StreamSubscription<AccelerometerEvent>? _acelerometroSubscription;
  bool processandoParada = false;
  DateTime? ultimaDetecaoDeMovimento;

  // Método unificado para iniciar ou finalizar a sangria
  Future<void> gerenciarSangria(
      BuildContext context, GeoPoint localizacao, User user,
      {bool iniciar = true}) async {
    if (iniciar) {
      inicioSangria = DateTime.now();
      String usuarioId = user.uid;
      WeatherApiService weatherService =
          WeatherApiService(apiKey: dotenv.env['OPENWEATHER_API_KEY']!);
      Map<String, dynamic> condicoesClimaticas = await weatherService
          .getCurrentWeather(localizacao.latitude, localizacao.longitude);
      sangriaAtual = Sangria(
          momento: DateTime.now(),
          duracaoTotal: Duration.zero,
          tabela: '',
          usuarioId: usuarioId,
          condicoesClimaticas: condicoesClimaticas,
          pontos: []);
      iniciarMonitoramentoAcelerometro();
      // Lógica para selecionar a tabela e iniciar a sangria
    } else {
      if (_acelerometroSubscription != null) {
        await _acelerometroSubscription!.cancel();
        _acelerometroSubscription = null;
      }
      if (inicioSangria != null && sangriaAtual != null) {
        final fimSangria = DateTime.now();
        sangriaAtual!.duracaoTotal = fimSangria.difference(inicioSangria!);

        // Salvando a sangria localmente usando o Hive
        LocalStorageService localStorageService = LocalStorageService();
        await localStorageService.saveSangria(sangriaAtual!);

        // Verificar se foi salvo no armazenamento local
        await localStorageService.listarSangriasSalvas();

        // Verificar conexão e sincronizar se necessário
        await localStorageService.verificarConexaoESincronizarSeNecessario();

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sangria finalizada com sucesso')));
      }
    }
  }

  void iniciarMonitoramentoAcelerometro() {
    _acelerometroSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) async {
      if (detectouParada(event)) {
        if (!processandoParada) {
          // Registra uma parada e marca o início dela
          processandoParada = true;
          inicioPontoAtual = DateTime.now();
          Vibration.vibrate(duration: 500); // Vibração como feedback
          // Registra o ponto de sangria imediatamente na parada
          _adicionarPontoDeSangria(
              inicioPontoAtual!, await obterLocalizacaoAtual(), 0);
        }
      } else {
        if (processandoParada && inicioPontoAtual != null) {
          var duracaoDesdeUltimaParada =
              DateTime.now().difference(inicioPontoAtual!).inSeconds;
          if (duracaoDesdeUltimaParada > 2) {
            // Se o movimento durar mais de 3 segundos, prepara para a próxima parada
            processandoParada = false;
          }
        }
        ultimaDetecaoDeMovimento = DateTime.now();
      }
    });
  }

  bool detectouParada(AccelerometerEvent event) {
    double magnitude =
        math.sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    bool parou = magnitude < 11; // Novo limiar ajustado
    print(
        "Magnitude ajustada: $magnitude, Parou: $parou"); // Log para diagnóstico
    return parou;
  }

  void _adicionarPontoDeSangria(
      DateTime timestamp, LatLng localizacao, int duracao) {
    var ponto = PontoDeSangria(
        id: ++proximoIdPonto,
        timestamp: timestamp,
        localizacao: localizacao,
        duracao: duracao);
    pontosDeSangria.add(ponto);
    // Salvar o ponto
  }

  Future<LatLng> obterLocalizacaoAtual() async {
    try {
      Position posicao = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(posicao.latitude, posicao.longitude);
    } catch (e) {
      print("Erro ao obter localização: $e");
      return LatLng(0, 0);
    }
  }
}



  // Certifique-se de que a lógica para adicionar pontos de sangria esteja correta
  // e que estejam sendo corretamente monitorados os eventos do acelerômetro.

