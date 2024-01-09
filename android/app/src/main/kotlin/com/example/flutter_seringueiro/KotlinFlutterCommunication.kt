import android.content.Intent
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.example.flutter_seringueiro.SangriaService
import com.example.flutter_seringueiro.MainActivity

class KotlinFlutterCommunication(private val channel: MethodChannel, private val activity: MainActivity) : MethodChannel.MethodCallHandler {

    init {
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "iniciarRegistroPontos" -> {
                val sangriaId = call.argument<String>("sangriaId")
                iniciarRegistroPontos(sangriaId, result)
            }
            "finalizarRegistroPontos" -> {
                val sangriaId = call.argument<String>("sangriaId")
                finalizarRegistroPontos(sangriaId, result)
            }
            else -> result.notImplemented()
        }
    }

    private fun iniciarRegistroPontos(sangriaId: String?, result: MethodChannel.Result) {
        val intent = Intent(activity, SangriaService::class.java).apply {
            putExtra("sangriaId", sangriaId)
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            activity.startForegroundService(intent)
        } else {
            activity.startService(intent)
        }
        result.success(null)
    }

    private fun finalizarRegistroPontos(sangriaId: String?, result: MethodChannel.Result) {
        val intent = Intent(activity, SangriaService::class.java).apply {
            action = SangriaService.ACTION_FINISH
            putExtra("sangriaId", sangriaId)
        }
        activity.startService(intent)
        result.success(null)
    }

    // Outras funções de comunicação
}
