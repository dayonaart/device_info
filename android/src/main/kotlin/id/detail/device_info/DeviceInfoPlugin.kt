package id.detail.device_info

import android.annotation.SuppressLint
import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.StandardMethodCodec
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.Response
import ru.gildor.coroutines.okhttp.await
import java.io.IOException
import java.util.*

/** DeviceInfoPlugin */
class DeviceInfoPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      val taskQueue =
          flutterPluginBinding.binaryMessenger.makeBackgroundTaskQueue()
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "device_info",
            StandardMethodCodec.INSTANCE,
            taskQueue)
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }
   val scope = CoroutineScope(Dispatchers.IO)
   @SuppressLint("HardwareIds")
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    scope.launch {
            when (call.method) {
                "getInformations" -> {
                    val androidId = Settings.Secure.getString(
                            context.contentResolver,
                            Settings.Secure.ANDROID_ID
                        )
                        val rand = List((20 - androidId.length)) {0}.joinToString("")
                    result.success(
                        """{"ip_address":"${deviceIpAndroid()}",
                                |"device_type":"${getDeviceName()}",
                                |"os_version":"${Build.VERSION.RELEASE}",
                                |"app_build_code":"${deviceVersion(context)?.versionName}",
                                |"app_version_code":"${versionCodeAndroid(deviceVersion(context))}",
                                |"uuid":"$androidId$rand"}""".trimMargin()
                    )
                }
                "getPublicIp" -> {
                    result.success(deviceIpAndroid())
                }
                "getUUID" -> {
                    try {
                      val androidId = Settings.Secure.getString(
                            context.contentResolver,
                            Settings.Secure.ANDROID_ID
                        )
                        val rand = List((20 - androidId.length)) {0}.joinToString("")
                        result.success("$androidId$rand")

                    } catch (e: Exception) {
                      val rand = List(7) {  (0..9).random()}.joinToString("")
                      val calendar = Calendar.getInstance()
                      val timestamp=calendar.timeInMillis
                      result.success("$timestamp$rand")
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}

private fun versionCodeAndroid(packageInfo: PackageInfo?): String {
    return try {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            "${packageInfo?.longVersionCode}"
        } else {
            "${packageInfo?.versionCode}"
        }
    } catch (e: Exception) {
        "version code not found"
    }
}

private suspend fun deviceIpAndroid(): String? {
    return try {
        getPublicIp().body()?.string()
    } catch (e: Exception) {
        return "ip address not found"
    }
}

private fun deviceVersion(context: Context): PackageInfo? {
    return try {
        context.packageManager
            .getPackageInfo(context.packageName, 0)
    } catch (e: PackageManager.NameNotFoundException) {
        e.printStackTrace()
        return null
    }
}

suspend fun getPublicIp(): Response {
    try {
        val client = OkHttpClient()
        val request = Request.Builder()
            .url("https://api.ipify.org/")
            .build()
        return client.newCall(request).await()
    } catch (e: IOException) {
        throw IOException("ip address not found")
    }
}

private fun getDeviceName(): String {
    val manufacturer = Build.MANUFACTURER
    val model = Build.MODEL
    return if (model.lowercase(Locale.getDefault())
            .startsWith(manufacturer.lowercase(Locale.getDefault()))
    ) {
        model.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() }
    } else {
        manufacturer.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.getDefault()) else it.toString() } + model
    }
}
