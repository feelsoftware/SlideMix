package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider

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

class MovieCreatorImpl(
    private val infoProvider: MovieInfoProvider,
    private val ffmpegProvider: FFmpegProvider
) : MovieCreator {
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

        val thumbResultCode = ffmpegProvider.execute(
            listOf(
                "-i", info.moviePath,
                "-ss", "00:00:00.500",
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
