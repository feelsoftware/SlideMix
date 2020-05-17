package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider
import com.vitoksmile.cpmoviemaker.utils.NumberFormatter

interface MovieCreator {
    fun createMovie(outputDir: String, scenesDir: String): Result

    fun dispose()

    sealed class Result {
        data class Success(
            val thumb: String,
            val movie: String
        ) : Result()

        data class Error(
            val message: String
        ) : Result()
    }
}

private const val THUMB_TIME_FORMAT = "HH:mm:ss.SSS"

class MovieCreatorImpl(
    private val infoProvider: MovieInfoProvider,
    private val ffmpegProvider: FFmpegProvider
) : MovieCreator {
    private val numberFormatter = NumberFormatter()

    override fun createMovie(
        outputDir: String,
        scenesDir: String
    ): MovieCreator.Result = run {
        val info = infoProvider.provideInfo(outputDir)

        val movieResultCode = ffmpegProvider.execute(
            listOf(
                "-framerate", "1",
                "-i", "${scenesDir}/image%03d.jpg",
                "-r", "30",
                "-pix_fmt", "yuv420p",
                "-y", info.moviePath
            )
        )
        if (movieResultCode != ffmpegProvider.returnCodeSuccess) {
            return@run MovieCreator.Result.Error("Failed to create a movie.")
        }

        val thumbTime = numberFormatter.formatMilliseconds(
            THUMB_TIME_FORMAT,
            ffmpegProvider.getMovieDuration(info.moviePath) / 2
        )
        val thumbResultCode = ffmpegProvider.execute(
            listOf(
                "-i", info.moviePath,
                "-ss", thumbTime,
                "-vframes", "1",
                info.thumbPath
            )
        )
        if (thumbResultCode != ffmpegProvider.returnCodeSuccess) {
            return@run MovieCreator.Result.Error("Failed to create a thumb.")
        }

        MovieCreator.Result.Success(
            thumb = info.thumbPath,
            movie = info.moviePath
        )
    }

    override fun dispose() {
        ffmpegProvider.cancel()
    }
}
