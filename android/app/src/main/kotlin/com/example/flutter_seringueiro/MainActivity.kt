package com.example.flutter_seringueiro

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.Log
import android.content.Intent
import android.os.Build

class MainActivity: FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.flutter_seringueiro/sangria")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "iniciarRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "pausarRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    intent.action = SangriaService.ACTION_PAUSE
                    startService(intent)
                    result.success(null)
                }
                "resumirRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    intent.action = SangriaService.ACTION_RESUME
                    startService(intent)
                    result.success(null)
                }
                "statusRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    intent.action = SangriaService.ACTION_STATUS
                    startService(intent)
                    result.success(null)
                }
                
                "cancelarRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    intent.action = SangriaService.ACTION_CANCEL
                    startService(intent)
                    result.success(null)
                }
                
                "finalizarRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    intent.action = SangriaService.ACTION_FINISH
                    startService(intent)
                    result.success(null)
                }
                
                else -> result.notImplemented()
            }
        }
    }
}
