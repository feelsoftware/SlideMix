@file:Suppress("UNCHECKED_CAST")

package com.feelsoftware.slidemix

import android.util.Log
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.feelsoftware.slidemix.channel.MovieCreatorChannel
import com.feelsoftware.slidemix.channel.MoviesRepositoryChannel
import com.feelsoftware.slidemix.channel.provideMovieCreatorChannel
import com.feelsoftware.slidemix.channel.provideMoviesRepositoryChannel
import com.feelsoftware.slidemix.provider.FFmpegProvider
import com.feelsoftware.slidemix.provider.FFmpegProviderImpl
import com.feelsoftware.slidemix.repository.provideMoviesRepository
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    // TODO: use DI
    private val movieCreatorChannel: MovieCreatorChannel by lazy {
        val ffmpegProvider: FFmpegProvider = FFmpegProviderImpl()
        provideMovieCreatorChannel(ffmpegProvider)
    }
    private val moviesRepositoryChannel: MoviesRepositoryChannel by lazy {
        val sqlDriver = AndroidSqliteDriver(MoviesDB.Schema, applicationContext, "movies.db")
        val repository = provideMoviesRepository(sqlDriver)
        provideMoviesRepositoryChannel(repository)
    }

    override fun onDestroy() {
        super.onDestroy()
        movieCreatorChannel.dispose()
        moviesRepositoryChannel.dispose()
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        registerMovieCreatorChannel(flutterEngine)
        registerMoviesRepositoryChannel(flutterEngine)
    }

    private fun registerMovieCreatorChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MovieCreatorChannel.CHANNEL)
            .setMethodCallHandler { call, result ->
                Log.d(MovieCreatorChannel.CHANNEL, "${call.method}: ${call.arguments}")

                movieCreatorChannel.methodCall(
                    method = call.method,
                    arguments = call.argumentsMap
                ) {
                    result.success(it)
                }
            }
    }

    private fun registerMoviesRepositoryChannel(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MoviesRepositoryChannel.CHANNEL)
            .setMethodCallHandler { call, result ->
                Log.d(MoviesRepositoryChannel.CHANNEL, "${call.method}: ${call.arguments}")

                moviesRepositoryChannel.methodCall(
                    method = call.method,
                    arguments = call.argumentsMap
                ) {
                    result.success(it)
                }
            }
    }
}

private val MethodCall.argumentsMap get() = arguments as? Map<String, Any> ?: emptyMap()
