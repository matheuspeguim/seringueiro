import 'package:flutter/services.dart';

class FlutterKotlinCommunication {
  static const MethodChannel _channel =
      MethodChannel('com.peguim.seringueiro/fieldActivity');

  static Future<void> startActivityPointsTracker(
      String fieldActivityId) async {}

  static Future<void> cancelActivityPointsTracker(
      String fieldActivityId) async {}

  static Future<void> finishActivityPointsTracker(
      String fieldActivityId) async {}

  // Outras funções de comunicação
}
