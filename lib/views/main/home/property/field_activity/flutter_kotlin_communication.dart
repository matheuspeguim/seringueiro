import 'package:flutter/services.dart';
import 'package:flutter_seringueiro/common/models/field_activity.dart';

class FlutterKotlinCommunication {
  static const MethodChannel _channel =
      MethodChannel('com.peguim.seringueiro/fieldActivity');

  static Future<void> startActivityPointsTracker(FieldActivity activity) async {
    try {
      await _channel.invokeMethod('startTracking', {
        'activityId': activity.id,
        'propertyId': activity.propertyId,
      });
    } on PlatformException catch (e) {
      print("Erro ao iniciar o rastreamento: ${e.message}");
    }
  }

  static Future<void> finishActivityPointsTracker(
      FieldActivity activity) async {
    try {
      await _channel.invokeMethod('finishTracking', {
        'activityId': activity.id, // Adiciona 'activityId' para consistência
      });
    } on PlatformException catch (e) {
      print("Erro ao finalizar o rastreamento: ${e.message}");
    }
  }
}
