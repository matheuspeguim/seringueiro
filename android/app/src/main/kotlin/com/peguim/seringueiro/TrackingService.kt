// Declaração do pacote onde esta classe está localizada.
package com.peguim.seringueiro

// Importações de classes e bibliotecas necessárias para o funcionamento do código.
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.*
import com.google.firebase.firestore.FirebaseFirestore

// Declaração da classe TrackingService, que é um serviço do Android.
// Este serviço é usado para executar operações em background.
class TrackingService : Service() {

    // Definição de constantes utilizadas no serviço.
    companion object {
        const val ACTION_START_TRACKING = "ACTION_START_TRACKING"
        const val ACTION_FINISH_TRACKING = "ACTION_FINISH_TRACKING"
        const val EXTRA_ACTIVITY_ID = "EXTRA_ACTIVITY_ID"
        const val EXTRA_PROPERTY_ID = "EXTRA_PROPERTY_ID"
        private const val CHANNEL_ID = "ForegroundServiceChannel"
        private const val NOTIFICATION_ID = 1
    }

    // Declaração de variáveis que serão inicializadas posteriormente.
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var locationCallback: LocationCallback
    private val handler = Handler(Looper.getMainLooper())
    private var propertyId: String? = null
    private var activityId: String? = null

    // Este método é chamado quando o serviço é criado. É um bom lugar para inicializações.
    override fun onCreate() {
        super.onCreate()
        createNotificationChannel() // Cria um canal de notificação para versões do Android Oreo ou
        // superiores.
    }

    // Este método é chamado toda vez que o serviço é iniciado.
    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        // Recupera os dados passados para o serviço.
        propertyId = intent?.getStringExtra(EXTRA_PROPERTY_ID)
        activityId = intent?.getStringExtra(EXTRA_ACTIVITY_ID)

        // Verifica se os dados necessários foram fornecidos. Se não, o serviço é encerrado.
        if (propertyId == null || activityId == null) {
            stopSelf()
            return START_NOT_STICKY
        }

        // Inicializa o cliente de localização e começa a coletar a localização.
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
        iniciarColetaDeLocalizacao()
        // Inicia o serviço em primeiro plano, mostrando uma notificação para o usuário.
        startForeground(NOTIFICATION_ID, getNotification())
        return START_NOT_STICKY
    }

    // Cria e retorna uma notificação para ser usada no serviço em primeiro plano.
    private fun getNotification(): Notification {
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0)

        return NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("Rastreamento de Atividade")
                .setContentText("Rastreamento de localização em andamento.")
                .setSmallIcon(R.drawable.ic_tracker) // Substitua pelo ícone desejado
                .setContentIntent(pendingIntent)
                .build()
    }

    // Cria um canal de notificação para versões do Android Oreo ou superiores.
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel =
                    NotificationChannel(
                            CHANNEL_ID,
                            "Serviço de Rastreamento de Atividade",
                            NotificationManager.IMPORTANCE_DEFAULT
                    )
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(serviceChannel)
        }
    }

    // Inicia a coleta de localização com configurações específicas.
    private fun iniciarColetaDeLocalizacao() {
        val locationRequest =
                LocationRequest.create().apply {
                    interval = 30000 // 30 segundos
                    priority = LocationRequest.PRIORITY_HIGH_ACCURACY
                }

        locationCallback =
                object : LocationCallback() {
                    override fun onLocationResult(locationResult: LocationResult) {
                        locationResult.locations.firstOrNull()?.let { location ->
                            registrarLocalizacaoAtual(location.latitude, location.longitude)
                        }
                        // Após receber a localização, remove as atualizações e reinicia o processo.
                        fusedLocationClient.removeLocationUpdates(this)
                        handler.postDelayed({ iniciarColetaDeLocalizacao() }, 30000)
                    }
                }

        // Solicita atualizações de localização com as configurações definidas.
        fusedLocationClient.requestLocationUpdates(
                locationRequest,
                locationCallback,
                Looper.getMainLooper()
        )
    }

    // Registra a localização atual no Firebase Firestore.
    private fun registrarLocalizacaoAtual(latitude: Double, longitude: Double) {
        val activityPoint =
                hashMapOf(
                        "momento" to System.currentTimeMillis(),
                        "latitude" to latitude,
                        "longitude" to longitude,
                        "fieldActivityId" to activityId
                )

        FirebaseFirestore.getInstance()
                .collection("activity_points")
                .add(activityPoint)
                .addOnSuccessListener { /* Sucesso */}
                .addOnFailureListener { /* Falha */}
    }

    // Este método retorna null porque este serviço não é vinculado com componentes.
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    // Método chamado quando o serviço é destruído. Um bom lugar para limpeza.
    override fun onDestroy() {
        pararColetaDeLocalizacao()
        super.onDestroy()
    }

    // Para a coleta de localização e limpa qualquer callback pendente.
    private fun pararColetaDeLocalizacao() {
        if (this::fusedLocationClient.isInitialized && this::locationCallback.isInitialized) {
            fusedLocationClient.removeLocationUpdates(locationCallback)
        }
        handler.removeCallbacksAndMessages(null)
    }
}
