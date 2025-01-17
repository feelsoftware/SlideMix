package com.feelsoftware.slidemix.ffmpeg

import android.os.Handler
import android.os.Looper
import com.arthenica.ffmpegkit.FFmpegKit
import com.arthenica.ffmpegkit.FFmpegKitConfig
import com.arthenica.ffmpegkit.FFmpegSession
import com.arthenica.ffmpegkit.FFprobeKit
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import kotlinx.serialization.Serializable
import kotlinx.serialization.json.Json

class FFmpegMethodChannel private constructor() :
    MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_EXECUTE -> {
                try {
                    val arguments = call.arguments<List<String>>()

                    val session = FFmpegSession.create(arguments.orEmpty().toTypedArray())
                    FFmpegKitConfig.ffmpegExecute(session)

                    val returnCode = FFmpegReturnCode(
                        isSuccess = session.returnCode.isValueSuccess,
                        isCancel = session.returnCode.isValueCancel,
                        isError = session.returnCode.isValueError,
                        logs = takeIf { session.returnCode.isValueError }
                            ?.let { session.logs.reversed().joinToString { it.message } }
                    )
                    val json = Json.encodeToString(returnCode)
                    result.success(json)
                } catch (error: Throwable) {
                    result.error("ERROR", error.message, error.stackTraceToString())
                }
            }

            METHOD_DURATION -> {
                try {
                    val path = call.arguments<String>()!!
                    val mediaInformation = FFprobeKit.getMediaInformation(path).mediaInformation
                    val duration = mediaInformation.duration.toDoubleOrNull() ?: 0.0
                    result.success(duration)
                } catch (error: Throwable) {
                    result.error("ERROR", error.message, error.stackTraceToString())
                }
            }

            METHOD_DISPOSE -> {
                FFmpegKit.cancel()
                result.success(true)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val duration = (arguments as? Int)?.toDouble()?.coerceAtLeast(0.1) ?: 1.0
        val handler = Handler(Looper.getMainLooper())
        FFmpegKitConfig.enableStatisticsCallback { statistic ->
            val progress = (statistic.time / duration)
                .coerceAtLeast(0.0)
                .coerceAtMost(1.0)
            handler.post { events.success(progress) }
        }
    }

    override fun onCancel(arguments: Any?) {
        FFmpegKitConfig.enableStatisticsCallback {}
    }

    companion object {

        private const val NAME = "com.feelsoftware.slidemix.ffmpeg"
        private const val NAME_PROGRESS = "com.feelsoftware.slidemix.ffmpeg.progress"

        private const val METHOD_EXECUTE = "execute"
        private const val METHOD_DURATION = "duration"
        private const val METHOD_DISPOSE = "dispose"

        fun attach(flutterEngine: FlutterEngine) {
            val implementation = FFmpegMethodChannel()
            val taskQueue = flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                NAME,
                StandardMethodCodec.INSTANCE,
                taskQueue,
            ).setMethodCallHandler(implementation)
            EventChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                NAME_PROGRESS,
                StandardMethodCodec.INSTANCE,
                taskQueue,
            ).setStreamHandler(implementation)
        }
    }
}

@Serializable
private data class FFmpegReturnCode(
    val isSuccess: Boolean,
    val isCancel: Boolean,
    val isError: Boolean,
    val logs: String?,
)
