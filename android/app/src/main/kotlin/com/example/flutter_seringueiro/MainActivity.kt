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
                    val sangriaId = call.argument<String>("sangriaId")
                    val intent = Intent(this, SangriaService::class.java).apply {
                        putExtra("sangriaId", sangriaId)
                    }
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                
                "cancelarRegistroPontos" -> {
                    val intent = Intent(this, SangriaService::class.java)
                    intent.action = SangriaService.ACTION_CANCEL
                    startService(intent)
                    result.success(null)
                }
                
                "finalizarRegistroPontos" -> {
                    val sangriaId = call.argument<String>("sangriaId") // Obter sangriaId do Flutter
                    val intent = Intent(this, SangriaService::class.java).apply {
                        action = SangriaService.ACTION_FINISH
                        putExtra("sangriaId", sangriaId) // Adicionar sangriaId ao Intent
                    }
                    startService(intent)
                    result.success(null)
                
                    transferirPontos(call, result)
                }

                "transferirPontosDeSangria" -> {
                    transferirPontos(call, result)
                }
                
                else -> result.notImplemented()
            }
        }
    }

    private fun transferirPontos(call: MethodCall, result: MethodChannel.Result) {
        val sangriaId = call.argument<String>("sangriaId")
        val pontosDeSangria = LocalStorageService(context).recuperarPontos(sangriaId ?: "")
        result.success(pontosDeSangria)
    }
}
