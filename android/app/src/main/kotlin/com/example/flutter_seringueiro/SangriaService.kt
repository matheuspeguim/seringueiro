package com.example.flutter_seringueiro

import android.annotation.SuppressLint
import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.drawable.Icon
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import kotlin.math.pow
import kotlin.math.sqrt

class SangriaService(private val messenger: BinaryMessenger? = null) : Service(), SensorEventListener, LocationListener {
    private lateinit var sensorManager: SensorManager
    private lateinit var locationManager: LocationManager
    private var sangriaId: String? = null
    private val pontosDeSangria = mutableListOf<PontoDeSangria>()
    private var inicioParada: Long? = null
    private var fimParada: Long? = null
    private var ultimaLocalizacao: Location? = null
    private val localStorageService = LocalStorageService(this)
    private lateinit var channel: MethodChannel
    private val notificationId = 1
    private val channelId = "sangria_service_channel"
    private var isMonitoringPaused = false
    private lateinit var fusedLocationClient: FusedLocationProviderClient

    override fun onCreate() {
        super.onCreate()
        createNotificationChannel()
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        messenger?.let {
            channel = MethodChannel(it, "com.seuapp/sangria")
        }
    }

    companion object {
        const val ACTION_PAUSE = "ACTION_PAUSE"
        const val ACTION_RESUME = "ACTION_RESUME"
        const val ACTION_STATUS = "ACTION_STATUS"
        const val ACTION_CANCEL = "ACTION_CANCEL"
        const val ACTION_FINISH = "ACTION_FINISH"
        // outras constantes
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        when (intent.action) {
            ACTION_PAUSE -> pauseMonitoring()
            ACTION_RESUME -> resumeMonitoring()
            ACTION_STATUS -> statusMonitoring()
            ACTION_CANCEL -> cancelMonitoring()
            ACTION_FINISH -> finishMonitoring()
            else -> super.onStartCommand(intent, flags, startId)
        }
        return START_STICKY
    }

    private fun pauseMonitoring() {
        sensorManager.unregisterListener(this)
        isMonitoringPaused = true
        updateNotification(pause = true)
    }

    private fun resumeMonitoring() {
        sensorManager.registerListener(this, sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER), SensorManager.SENSOR_DELAY_NORMAL)
        isMonitoringPaused = false
        updateNotification(pause = false)
    }

    private fun statusMonitoring() {

    }

    private fun cancelMonitoring() {
        cancelarSangria()
    }

    private fun finishMonitoring() {
        sensorManager.unregisterListener(this)
        finalizarSangria()
        stopSelf()
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
        val pauseIntent = PendingIntent.getService(
            this, 0, Intent(this, SangriaService::class.java).apply {
                action = "ACTION_PAUSE"
            }, PendingIntent.FLAG_UPDATE_CURRENT
        )
    
        val playIntent = PendingIntent.getService(
            this, 0, Intent(this, SangriaService::class.java).apply {
                action = "ACTION_PLAY"
            }, PendingIntent.FLAG_UPDATE_CURRENT
        )
    
        val stopIntent = PendingIntent.getService(
            this, 0, Intent(this, SangriaService::class.java).apply {
                action = "ACTION_STOP"
            }, PendingIntent.FLAG_UPDATE_CURRENT
        )
    
        // Construindo a notificação com ações dinâmicas baseadas no estado de pausa
        val notificationBuilder = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            Notification.Builder(this, channelId)
                .setContentTitle("Sangria em Andamento")
                .setContentText("Toque para gerenciar")
                .setSmallIcon(R.drawable.ic_notification)
                .setOngoing(true)
        } else {
            TODO("VERSION.SDK_INT < O")
        }

        if (isMonitoringPaused) {
            val playAction = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Notification.Action.Builder(
                    Icon.createWithResource(this, R.drawable.ic_play),
                    "Continuar",
                    playIntent
                ).build()
            } else {
                TODO("VERSION.SDK_INT < M")
            }
            notificationBuilder.addAction(playAction)
        } else {
            val pauseAction = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                Notification.Action.Builder(
                    Icon.createWithResource(this, R.drawable.ic_pause),
                    "Pausar",
                    pauseIntent
                ).build()
            } else {
                TODO("VERSION.SDK_INT < M")
            }
            notificationBuilder.addAction(pauseAction)
        }
    
        val stopAction = Notification.Action.Builder(
            Icon.createWithResource(this, R.drawable.ic_stop),
            "Finalizar",
            stopIntent
        ).build()
        notificationBuilder.addAction(stopAction)
    
        return notificationBuilder.build()
    }
    
    private fun cancelNotification() {
        val notificationManager: NotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.cancel(notificationId)
    }

    private fun updateNotification(pause: Boolean) {
        val notification = createNotification()
        val notificationManager: NotificationManager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(notificationId, notification)
    }

    private fun iniciarMonitoramentoAcelerometro() {
        sensorManager = getSystemService(SENSOR_SERVICE) as SensorManager
        sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER)?.also { acelerometro ->
            sensorManager.registerListener(this, acelerometro, SensorManager.SENSOR_DELAY_NORMAL)
        }
    }

    @SuppressLint("MissingPermission")
    private fun iniciarMonitoramentoGPS() {
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

    override fun onSensorChanged(event: SensorEvent?) {
        event?.let {
            val magnitude = sqrt(it.values[0].pow(2) + it.values[1].pow(2) + it.values[2].pow(2))
            if (magnitude < 10.5) {
                if (inicioParada == null) {
                    inicioParada = System.currentTimeMillis()
                    // Usuário parou, ativar GPS para obter localização
                    iniciarMonitoramentoGPS()
                }
            } else if (inicioParada != null) {
                // Usuário retomou movimento, desativar GPS se necessário
                locationManager.removeUpdates(this)
                fimParada = System.currentTimeMillis()
                registrarNovoPontoDeSangria()
                inicioParada = null
                fimParada = null
            }
        }
    }

    private fun registrarNovoPontoDeSangria() {
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
            salvarPontoDeSangriaLocalmente(ponto)

            // Adiciona a vibração aqui
            feedbackTatil()
        }
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
    
    

    private fun calcularDuracao(): Int {
        return ((fimParada ?: System.currentTimeMillis()) - (inicioParada ?: System.currentTimeMillis())).toInt()
    }

    override fun onLocationChanged(location: Location) {
        ultimaLocalizacao = location
        // Processar localização e desativar GPS
        locationManager.removeUpdates(this)
    }

    private fun salvarPontoDeSangriaLocalmente(ponto: PontoDeSangria) {
        localStorageService.inserirPonto(ponto)
    }

    fun cancelarSangria() {
        // 1. Interromper a leitura dos sensores
        sensorManager.unregisterListener(this)
        locationManager.removeUpdates(this)
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
        val pontosDeSangria = localStorageService.recuperarPontos(sangriaId!!)
        val pontosMapList = pontosDeSangria.map { it.toMap() }
        channel.invokeMethod("transferirPontosDeSangria", pontosMapList)
    }    

    override fun onBind(intent: Intent): IBinder? {
        return null
    }

    override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {
        // Implementação opcional...
    }
}