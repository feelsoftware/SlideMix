package com.vitoksmile.cpmoviemaker

import com.arthenica.mobileffmpeg.Config.RETURN_CODE_SUCCESS
import com.arthenica.mobileffmpeg.FFmpeg
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider

interface MovieCreator {
    suspend fun createMovie(outputDir: String, scenesDir: String): Result

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
    private val infoProvider: MovieInfoProvider
) : MovieCreator {
    override suspend fun createMovie(
        outputDir: String,
        scenesDir: String
    ): MovieCreator.Result = run {
        val info = infoProvider.provideInfo(outputDir)

        val movieResultCode = FFmpeg.execute(
            arrayOf(
                "-framerate", "1",
                "-i", "${scenesDir}/image%03d.jpg",
                "-r", "30",
                "-pix_fmt", "yuv420p",
                "-y", info.moviePath
            )
        )
        if (movieResultCode != RETURN_CODE_SUCCESS) {
            return@run MovieCreator.Result.Error("Failed to create a movie.")
        }

        val thumbResultCode = FFmpeg.execute(
            arrayOf(
                "-i", info.moviePath,
                "-ss", "00:00:00.500",
                "-vframes", "1",
                info.thumbPath
            )
        )
        if (thumbResultCode != RETURN_CODE_SUCCESS) {
            return@run MovieCreator.Result.Error("Failed to create a thumb.")
        }

        MovieCreator.Result.Success(
            thumb = info.thumbPath,
            movie = info.moviePath
        )
    }

    override fun dispose() {
        FFmpeg.cancel()
    }
}
