import 'package:flutter/services.dart';

class FlutterKotlinCommunication {
  static const MethodChannel _channel =
      MethodChannel('com.peguim.seringueiro/sangria');

  static Future<void> iniciarRegistroPontos(String fieldActivityId) async {
    await _channel.invokeMethod(
        'iniciarRegistroPontos', {'fieldActivityId': fieldActivityId});
  }

  static Future<List<dynamic>?> finalizarRegistroPontos(
      String sangriaId) async {
    try {
      // Faz a chamada para o método e espera pela lista de pontos como resposta
      final response = await _channel
          .invokeMethod('finalizarRegistroPontos', {'sangriaId': sangriaId});
      return response as List<dynamic>?;
    } catch (e) {
      print("Erro ao finalizar registro de pontos: $e");
      return null;
    }
  }

  // Outras funções de comunicação
}
