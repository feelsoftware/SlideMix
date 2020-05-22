@file:Suppress("SpellCheckingInspection")

package com.vitoksmile.cpmoviemaker.provider

import kotlin.math.min

interface FFmpegCommandsProvider {
    companion object {
        const val THUMB_TIME_FORMAT = "HH:mm:ss.SSS"
    }

    /**
     * Provide a command to create a movie from files in the [scenesDir] and
     * store this movie in by the [moviePath].
     */
    fun createMovieCommand(scenesDir: String, moviePath: String): List<String>

    /**
     * Provide a command to create a thumb from a movie.
     */
    fun createThumbCommand(moviePath: String, thumbTime: String, thumbPath: String): List<String>
}

object FFmpegCommandsProviderImpl : FFmpegCommandsProvider {
    private val paramsProvider = FFmpegEncodingParamsProvider()

    override fun createMovieCommand(
        scenesDir: String,
        moviePath: String
    ) = listOf(
        "-framerate", "1",
        "-i", "${scenesDir}/image%03d.jpg",
        "-r", "30"
    ) + movieParams() + listOf(
        "-pix_fmt", "yuv420p",
        "-y", moviePath
    )

    override fun createThumbCommand(
        moviePath: String,
        thumbTime: String,
        thumbPath: String
    ) = listOf(
        "-i", moviePath,
        "-ss", thumbTime,
        "-vframes", "1",
        thumbPath
    )

    private fun movieParams(): List<String> {
        val params = paramsProvider.provideParams()
        return if (params.resolution == null) {
            emptyList()
        } else {
            val pixels = min(params.resolution.width, params.resolution.height)
            listOf(
                "-vf", "scale='if(gt(iw,ih),-2,min($pixels,iw))':'if(gt(iw,ih),min($pixels,iw),-2)'"
            )
        }
    }
}

fun provideFFmpegCommandsProvider(): FFmpegCommandsProvider = FFmpegCommandsProviderImpl
