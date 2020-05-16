@file:Suppress("UNCHECKED_CAST")

package com.vitoksmile.cpmoviemaker

import android.os.Bundle
import android.util.Log
import com.arthenica.mobileffmpeg.Config
import com.arthenica.mobileffmpeg.FFmpeg
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.*
import java.io.File
import java.util.*

private const val CREATION_CHANNEL = "com.vitoksmile.cpmoviemaker.CREATION_CHANNEL"
private const val CREATION_METHOD_CREATE = "CREATION_METHOD_CREATE"
private const val CREATION_METHOD_CANCEL = "CREATION_METHOD_CANCEL"

class MainActivity : FlutterActivity() {
    private val ffmpegCoroutineContext = SupervisorJob() + Dispatchers.IO
    private val ffmpegCoroutineScope = CoroutineScope(ffmpegCoroutineContext)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        registerFFmpegChannel()
    }

    override fun onDestroy() {
        super.onDestroy()
        cancelCreation(result = null)
    }

    private fun registerFFmpegChannel() {
        MethodChannel(flutterView, CREATION_CHANNEL).setMethodCallHandler { methodCall, result ->
            Log.d(CREATION_CHANNEL, "${methodCall.method}: ${methodCall.arguments}")
            when (methodCall.method) {
                CREATION_METHOD_CREATE -> {
                    val arguments = methodCall.arguments as? List<String> ?: run {
                        result.error("ERROR", "Invalid type of arguments, must be List<String>.", null)
                        return@setMethodCallHandler
                    }
                    if (arguments.size != 2) {
                        result.error("ERROR", "Invalid count of arguments, must be 2: outputDir and scenesDir.", null)
                        return@setMethodCallHandler
                    }
                    createMovie(outputDir = arguments[0], scenesDir = arguments[1], result = result)
                }
                CREATION_METHOD_CANCEL -> {
                    cancelCreation(result)
                }
            }
        }
    }

    private fun createMovie(outputDir: String, scenesDir: String, result: MethodChannel.Result) {
        File(outputDir).listFiles()
        val moviePath = File(outputDir, generateMovieName(File(outputDir))).path

        ffmpegCoroutineScope.launch {
            val resultCode = FFmpeg.execute(arrayOf(
                    "-framerate", "1",
                    "-i", "${scenesDir}/image%03d.jpg",
                    "-r", "30",
                    "-pix_fmt", "yuv420p",
                    "-y", moviePath
            ))
            withContext(Dispatchers.Main) {
                when (resultCode) {
                    Config.RETURN_CODE_SUCCESS ->
                        result.success(moviePath)

                    Config.RETURN_CODE_CANCEL ->
                        result.error("ERROR", "Canceled by user.", null)

                    else ->
                        result.error("ERROR", "Command execution failed.", null)
                }
            }
        }
    }

    private fun cancelCreation(result: MethodChannel.Result?) {
        FFmpeg.cancel()
        ffmpegCoroutineContext.cancelChildren()
        result?.success(1)
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
