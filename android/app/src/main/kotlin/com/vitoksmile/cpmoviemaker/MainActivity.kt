@file:Suppress("UNCHECKED_CAST")

package com.vitoksmile.cpmoviemaker

import android.os.Bundle
import android.util.Log
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.*

private const val ERROR_CODE = "ERROR"

private const val CREATION_CHANNEL = "com.vitoksmile.cpmoviemaker.CREATION_CHANNEL"
private const val CREATION_METHOD_CREATE = "CREATION_METHOD_CREATE"
private const val CREATION_METHOD_CANCEL = "CREATION_METHOD_CANCEL"

private const val CREATION_RESULT_KEY_THUMB = "CREATION_RESULT_KEY_THUMB"
private const val CREATION_RESULT_KEY_MOVIE = "CREATION_RESULT_KEY_MOVIE"

class MainActivity : FlutterActivity() {
    private val ffmpegCoroutineContext = SupervisorJob() + Dispatchers.Unconfined
    private val ffmpegCoroutineScope = CoroutineScope(ffmpegCoroutineContext)

    // TODO: use DI
    private val infoProvider: MovieInfoProvider = MovieInfoProviderImpl()
    private val movieCreator: MovieCreator = MovieCreatorImpl(infoProvider)

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        registerFFmpegChannel()
    }

    override fun onDestroy() {
        super.onDestroy()
        creationMethodCancel(result = null)
    }

    private fun registerFFmpegChannel() {
        MethodChannel(flutterView, CREATION_CHANNEL).setMethodCallHandler { call, result ->
            Log.d(CREATION_CHANNEL, "${call.method}: ${call.arguments}")

            when (call.method) {
                CREATION_METHOD_CREATE -> creationMethodCreate(call, result)
                CREATION_METHOD_CANCEL -> creationMethodCancel(result)
            }
        }
    }

    private fun creationMethodCreate(call: MethodCall, result: MethodChannel.Result) {
        val arguments = call.arguments as? List<String> ?: run {
            result.error("Invalid type of arguments, must be List<String>.")
            return
        }
        if (arguments.size != 2) {
            result.error("Invalid count of arguments, must be 2: outputDir and scenesDir.")
            return
        }
        createMovie(
            outputDir = arguments[0],
            scenesDir = arguments[1],
            result = result
        )
    }

    private fun createMovie(
        outputDir: String,
        scenesDir: String,
        result: MethodChannel.Result
    ) {
        ffmpegCoroutineScope.launch(Dispatchers.Main) {
            val creationResult = withContext(Dispatchers.IO) {
                movieCreator.createMovie(outputDir, scenesDir)
            }
            when (creationResult) {
                is MovieCreator.Result.Success -> {
                    result.success(
                        mapOf(
                            CREATION_RESULT_KEY_THUMB to creationResult.thumb,
                            CREATION_RESULT_KEY_MOVIE to creationResult.movie
                        )
                    )
                }

                is MovieCreator.Result.Error -> {
                    result.error(creationResult.message)
                }
            }
        }
    }

    private fun creationMethodCancel(result: MethodChannel.Result?) {
        movieCreator.dispose()
        ffmpegCoroutineContext.cancelChildren()
        result?.success(1)
    }
}

private fun MethodChannel.Result.error(message: String) {
    error(ERROR_CODE, message, null)
}
