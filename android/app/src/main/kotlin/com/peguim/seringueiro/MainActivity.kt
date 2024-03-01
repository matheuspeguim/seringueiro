package com.peguim.seringueiro

import android.content.Intent
import android.os.Bundle
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.peguim.seringueiro/fieldActivity"
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startTracking" -> handleStartTracking(call, result)
                "finishTracking" -> handleFinishTracking(call, result)
                else -> result.notImplemented()
            }
        }
    }

    private fun handleStartTracking(call: MethodCall, result: MethodChannel.Result) {
        val activityId = call.argument<String>("activityId")
        val propertyId = call.argument<String>("propertyId")

        // Verifica se os IDs necessários estão presentes
        if (activityId.isNullOrEmpty() || propertyId.isNullOrEmpty()) {
            Log.e("MainActivity", "ID da atividade ou ID da propriedade faltando.")
            result.error("ERROR_MISSING_IDS", "ID da atividade ou ID da propriedade faltando.", null)
            return
        }

        // Inicia o serviço com a ação específica para iniciar o rastreamento
        Intent(this, TrackingService::class.java).also { intent ->
            intent.action = TrackingService.ACTION_START_TRACKING
            intent.putExtra(TrackingService.EXTRA_ACTIVITY_ID, activityId)
            intent.putExtra(TrackingService.EXTRA_PROPERTY_ID, propertyId)
            startService(intent)
        }
        result.success("Rastreamento iniciado com sucesso.")
    }

    private fun handleFinishTracking(call: MethodCall, result: MethodChannel.Result) {
        val activityId = call.argument<String>("activityId")

        if (activityId.isNullOrEmpty()) {
            Log.e("MainActivity", "ID da atividade faltando para terminar o rastreamento.")
            result.error("ERROR_MISSING_ACTIVITY_ID", "ID da atividade faltando para terminar o rastreamento.", null)
            return
        }

        // Inicia o serviço com a ação específica para terminar o rastreamento
        Intent(this, TrackingService::class.java).also { intent ->
            intent.action = TrackingService.ACTION_FINISH_TRACKING
            intent.putExtra(TrackingService.EXTRA_ACTIVITY_ID, activityId)
            startService(intent)
        }
        result.success("Rastreamento finalizado com sucesso.")
    }
}
