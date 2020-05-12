@file:Suppress("UNCHECKED_CAST")

package com.vitoksmile.cpmoviemaker

import android.os.Bundle
import com.arthenica.mobileffmpeg.FFmpeg
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.io.File
import java.util.*
import kotlin.concurrent.thread

private const val CHANNEL = "com.vitoksmile.cpmoviemaker.CHANNEL"
private const val METHOD_CREATE = "METHOD_CREATE"
private const val METHOD_CANCEL = "METHOD_CANCEL"

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
                    val arguments = methodCall.arguments as? List<String> ?: run {
                        result.error("Invalid type of arguments, must be List<String>.", null, null)
                        return@setMethodCallHandler
                    }
                    if (arguments.size != 2) {
                        result.error("Invalid count of arguments, must be 2: outputDir and scenesDir.", null, null)
                        return@setMethodCallHandler
                    }
                    createMovie(outputDir = arguments[0], scenesDir = arguments[1], result = result)
                }
                METHOD_CANCEL -> {
                    cancelCreation(result)
                }
            }
        }
    }

    private fun createMovie(outputDir: String, scenesDir: String, result: MethodChannel.Result) {
        File(outputDir).listFiles()
        val moviePath = File(outputDir, generateMovieName(File(outputDir))).path

        thread {
            FFmpeg.execute("-framerate 1 -i ${scenesDir}/image%03d.jpg -r 30 -pix_fmt yuv420p -y $moviePath")
            runOnUiThread {
                result.success(moviePath)
            }
        }
    }

    private fun cancelCreation(result: MethodChannel.Result) {
        FFmpeg.cancel()
        result.success(1)
    }

    private fun generateMovieName(dir: File): String {
        fun generateMovieName() = "${UUID.randomUUID()}.mp4"

        var name = generateMovieName()
        val files = dir.listFiles().map { it.name }
        while (files.contains(name)) {
            name = generateMovieName()
        }
        return name
    }
}
