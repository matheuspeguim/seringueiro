package com.example.flutter_seringueiro

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import KotlinFlutterCommunication

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.flutter_seringueiro/sangria")
        val communicationHandler = KotlinFlutterCommunication(channel, this)
    }
}
