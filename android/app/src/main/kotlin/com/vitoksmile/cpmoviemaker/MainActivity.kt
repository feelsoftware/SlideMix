@file:Suppress("UNCHECKED_CAST")

package com.vitoksmile.cpmoviemaker

import android.os.Bundle
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.concurrent.thread

private const val CHANNEL = "com.vitoksmile.cpmoviemaker.CHANNEL"
private const val METHOD_CREATE = "METHOD_CREATE"
private const val METHOD_CANCEL = "METHOD_CANCEL"
private const val METHOD_PROGRESS = "METHOD_PROGRESS"
private const val METHOD_READY = "METHOD_READY"
private const val METHOD_ERROR = "METHOD_ERROR"

class MainActivity : FlutterActivity() {
    private lateinit var ffmpegChannel: MethodChannel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        registerFFmpegChannel()
    }

    private fun registerFFmpegChannel() {
        ffmpegChannel = MethodChannel(flutterView, CHANNEL)
        ffmpegChannel.setMethodCallHandler { methodCall, result ->
            when (methodCall.method) {
                METHOD_CREATE -> {
                    val files = methodCall.arguments as? List<String> ?: run {
                        result.error("Invalid type of arguments", null, null)
                        return@setMethodCallHandler
                    }
                    createMovie(files, result)
                }
                METHOD_CANCEL -> {
                    cancelCreation(result)
                }
            }
        }
    }

    private fun createMovie(files: List<String>, result: MethodChannel.Result) {
        result.success(1)

        // TODO: run FFmpeg command to create video from files
        thread {
            Thread.sleep(500)
            for (i in 0..100) {
                Thread.sleep(10)
                runOnUiThread {
                    ffmpegChannel.invokeMethod(METHOD_PROGRESS, i)
                }
            }
            runOnUiThread {
                ffmpegChannel.invokeMethod(METHOD_READY, "Path to movie")
            }
        }
    }

    private fun cancelCreation(result: MethodChannel.Result) {
        // TODO: cancel FFmpeg
        result.success(1)
    }
}
