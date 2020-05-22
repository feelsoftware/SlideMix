@file:Suppress("SpellCheckingInspection")

package com.vitoksmile.cpmoviemaker.provider

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
    override fun createMovieCommand(
        scenesDir: String,
        moviePath: String
    ) = listOf(
        "-framerate", "1",
        "-i", "${scenesDir}/image%03d.jpg",
        "-r", "30",
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
}

fun provideFFmpegCommandsProvider(): FFmpegCommandsProvider = FFmpegCommandsProviderImpl
