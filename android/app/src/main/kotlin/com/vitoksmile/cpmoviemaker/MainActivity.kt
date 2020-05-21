@file:Suppress("UNCHECKED_CAST")

package com.vitoksmile.cpmoviemaker

import android.os.Bundle
import android.util.Log
import com.squareup.sqldelight.android.AndroidSqliteDriver
import com.vitoksmile.cpmoviemaker.channel.MovieCreatorChannel
import com.vitoksmile.cpmoviemaker.channel.MoviesRepositoryChannel
import com.vitoksmile.cpmoviemaker.channel.provideMovieCreatorChannel
import com.vitoksmile.cpmoviemaker.channel.provideMoviesRepositoryChannel
import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.FFmpegProviderImpl
import com.vitoksmile.cpmoviemaker.repository.provideMoviesRepository
import io.flutter.app.FlutterActivity
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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        registerMovieCreatorChannel()
        registerMoviesRepositoryChannel()
    }

    override fun onDestroy() {
        super.onDestroy()
        movieCreatorChannel.dispose()
        moviesRepositoryChannel.dispose()
    }

    private fun registerMovieCreatorChannel() {
        MethodChannel(flutterView, MovieCreatorChannel.CHANNEL)
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

    private fun registerMoviesRepositoryChannel() {
        MethodChannel(flutterView, MoviesRepositoryChannel.CHANNEL)
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
