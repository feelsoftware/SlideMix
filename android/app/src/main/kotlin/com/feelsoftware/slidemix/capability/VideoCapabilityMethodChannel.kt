package com.feelsoftware.slidemix.capability

import android.annotation.SuppressLint
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.StandardMethodCodec
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json

class VideoCapabilityMethodChannel : MethodChannel.MethodCallHandler {

    @SuppressLint("WrongThread")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            METHOD_GET -> {
                try {
                    val capability = VideoCapabilityProvider().getVideoCapabilities()
                    val json = Json.encodeToString(capability)
                    result.success(json)
                } catch (error: Throwable) {
                    result.error("ERROR", error.message, error.stackTraceToString())
                }
            }

            else -> result.notImplemented()
        }
    }

    companion object {
        private const val NAME = "com.feelsoftware.slidemix.capability.VideoCapability"

        private const val METHOD_GET = "get"

        fun attach(flutterEngine: FlutterEngine) {
            val taskQueue = flutterEngine.dartExecutor.binaryMessenger.makeBackgroundTaskQueue()
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                NAME,
                StandardMethodCodec.INSTANCE,
                taskQueue,
            ).setMethodCallHandler(VideoCapabilityMethodChannel())
        }
    }
}