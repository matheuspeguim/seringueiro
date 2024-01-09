package com.example.flutter_seringueiro

import android.annotation.SuppressLint
import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.drawable.Icon
import android.hardware.Sensor
import android.location.Location
import android.location.LocationListener
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import android.os.Handler
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import kotlin.math.pow
import kotlin.math.sqrt
import android.util.Log
import com.example.flutter_seringueiro.R


class SangriaService(private val messenger: BinaryMessenger? = null) : Service() {
    private var sangriaId: String? = null
    private val pontosDeSangria = mutableListOf<PontoDeSangria>()
    private var fimParada: Long? = null
    private var ultimaLocalizacao: Location? = null
    private val localStorageService = LocalStorageService(this)
    private lateinit var channel: MethodChannel
    private val notificationId = 1
    private val channelId = "sangria_service_channel"
    private var isMonitoringPaused = false
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var estaEmMovimento = false
    private var ultimaVezEmMovimento: Long? = null
    private var inicioParada: Long? = null
    private val handler = Handler(Looper.getMainLooper())
    private val intervalo = 5 * 60 * 1000L // 5 minutos em milissegundos, convertido para Long

    override fun onCreate() {
        super.onCreate()
        Log.d("SangriaService", "Serviço criado.")
        createNotificationChannel()
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        messenger?.let {
            channel = MethodChannel(it, "com.example.flutter_seringueiro/sangria")
        }
    }

    companion object {
        const val ACTION_CANCEL = "ACTION_CANCEL"
        const val ACTION_FINISH = "ACTION_FINISH"
        // outras constantes
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        sangriaId = intent.getStringExtra("sangriaId")
        Log.d("SangriaService", "Serviço iniciado com sangriaId: $sangriaId e ação: ${intent.action}")
        val notification = createNotification()
        startForeground(notificationId, notification)
    
        // Inicia o cronômetro para monitoramento periódico
        handler.post(runnable)
    
        when (intent.action) {
            ACTION_CANCEL -> cancelMonitoring()
            ACTION_FINISH -> finishMonitoring()
        }
        return START_STICKY
    }
    
    

    private fun cancelMonitoring() {
        cancelarSangria()
        Log.d("SangriaService", "Monitoramento cancelado.")
    }

    private fun finishMonitoring() {
        finalizarSangria()
        stopSelf()
        Log.d("SangriaService", "Monitoramento finalizado.")
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                "Sangria Service Channel",
                NotificationManager.IMPORTANCE_HIGH // Definindo a importância aqui
            ).apply {
                description = "Canal para o serviço de sangria"
            }
            val notificationManager: NotificationManager =
                getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun createNotification(): Notification {
        val finishIntent = PendingIntent.getService(
            this, 0, Intent(this, SangriaService::class.java).apply {
                action = ACTION_FINISH
            }, PendingIntent.FLAG_UPDATE_CURRENT
        )
    
        val cancelIntent = PendingIntent.getService(
            this, 0, Intent(this, SangriaService::class.java).apply {
                action = ACTION_CANCEL
            }, PendingIntent.FLAG_UPDATE_CURRENT
        )
    
        val notificationBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
                .setContentTitle("Sangria em Andamento")
                .setContentText("Guarde o celular no bolso e retorne quando terminar.")
                .setSmallIcon(R.drawable.icon) // Ícone obrigatório
                .addAction(Notification.Action.Builder(null, "Finalizar", finishIntent).build()) // Botão Finalizar
                .addAction(Notification.Action.Builder(null, "Cancelar", cancelIntent).build()) // Botão Cancelar
                .setStyle(Notification.BigTextStyle().bigText("Guarde o celular no bolso e retorne quando terminar."))
                .setPriority(Notification.PRIORITY_MAX) // Definir a prioridade para a visibilidade máxima
                .setOngoing(true) // Torna a notificação não removível
        } else {
            // Implementação para versões anteriores do Android
            TODO("VERSION.SDK_INT < O")
        }
    
        return notificationBuilder.build()
    }
    
    
    
    
    
    
    private fun cancelNotification() {
        val notificationManager: NotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(notificationId)
    }

    private val runnable = object : Runnable {
        override fun run() {
            iniciarMonitoramentoGPS()
            registrarNovoPontoDeSangria()
            handler.postDelayed(this, intervalo)
        }
    }

    
    @SuppressLint("MissingPermission") //Avisa o sistema que não é necessário avisar a falta de permissão.
    
    private fun iniciarMonitoramentoGPS() {
        Log.d("SangriaService", "Iniciando monitoramento do GPS.")
        val locationRequest = LocationRequest.Builder(10000L).apply {
            // Outras configurações, se necessário
        }.build()

        fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper())
    }

    private val locationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult) {
            // Processar a localização obtida
            ultimaLocalizacao = locationResult.lastLocation
            // Desativar futuras atualizações
            fusedLocationClient.removeLocationUpdates(this)
        }
    }

    private fun calcularDuracao(): Int {
        return ((fimParada ?: System.currentTimeMillis()) - (inicioParada ?: System.currentTimeMillis())).toInt()
    }

    private fun registrarNovoPontoDeSangria() {
        Log.d("SangriaService", "Registrando novo ponto de sangria. SangriaId: $sangriaId")
        fimParada = System.currentTimeMillis()
        ultimaLocalizacao?.let { location ->
            val ponto = PontoDeSangria(
                id = pontosDeSangria.size + 1,
                timestamp = System.currentTimeMillis(),
                latitude = location.latitude,
                longitude = location.longitude,
                duracao = calcularDuracao(),
                sangriaId = sangriaId ?: return
            )
            pontosDeSangria.add(ponto)
    
            // Salvando o ponto de sangria localmente
            Log.d("SangriaService", "Salvando Ponto de Sangria localmente")
            localStorageService.inserirPonto(ponto)
    
            // Adiciona a vibração aqui
            //feedbackTatil()
        }
        fimParada = null
    }
    

    private fun feedbackTatil() {
        val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            val vibratorManager = getSystemService(VIBRATOR_MANAGER_SERVICE) as VibratorManager
            vibratorManager.defaultVibrator
        } else {
            @Suppress("DEPRECATION")
            getSystemService(VIBRATOR_SERVICE) as Vibrator
        }
    
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Para Android Oreo ou superior, você pode criar um efeito de vibração mais complexo
            val effect = VibrationEffect.createOneShot(500, VibrationEffect.DEFAULT_AMPLITUDE)
            vibrator.vibrate(effect)
        } else {
            // Para versões anteriores do Android, usa um método de vibração simples
            @Suppress("DEPRECATION")
            vibrator.vibrate(500)
        }
    }

    fun cancelarSangria() {
        Log.d("SangriaService", "Cancelando sangria.")
        // 1. Interromper a leitura dos sensores
        fusedLocationClient.removeLocationUpdates(locationCallback)
    
        // 2. Excluir os pontos de sangria salvos associados ao ID da sangria cancelada
        sangriaId?.let { id ->
            localStorageService.deletarPontos(sangriaId = id)
        }
    
        // 3. Zerar variáveis relacionadas ao processo de sangria
        sangriaId = null
        pontosDeSangria.clear()
        inicioParada = null
        fimParada = null
        ultimaLocalizacao = null
    
        // 4. Cancelar a notificação
        cancelNotification()
    }

    fun finalizarSangria() {
        Log.d("SangriaService", "Finalizando sangria.")
        sangriaId?.let { id ->
            val pontosDeSangria = localStorageService.recuperarPontos(id)
            val pontosMapList = pontosDeSangria.map { it.toMap() }
        } ?: Log.e("SangriaService", "sangriaId é nulo.")
    }
      

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacks(runnable)
    }
}