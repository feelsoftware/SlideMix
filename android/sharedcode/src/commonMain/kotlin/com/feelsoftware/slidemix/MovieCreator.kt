@file:Suppress("BooleanLiteralArgument")

package com.feelsoftware.slidemix

import com.feelsoftware.slidemix.atomic.AtomicBoolean
import com.feelsoftware.slidemix.model.MovieCreatorResult
import com.feelsoftware.slidemix.provider.FFmpegCommandsProvider
import com.feelsoftware.slidemix.provider.FFmpegCommandsProvider.Companion.THUMB_TIME_FORMAT
import com.feelsoftware.slidemix.provider.FFmpegProvider
import com.feelsoftware.slidemix.provider.MovieInfoProvider
import com.feelsoftware.slidemix.utils.NumberFormatter

interface MovieCreator {
    fun createMovie(outputDir: String, scenesDir: String): MovieCreatorResult

    fun dispose()
}

class MovieCreatorImpl(
    private val infoProvider: MovieInfoProvider,
    private val ffmpegProvider: FFmpegProvider,
    private val ffmpegCommandsProvider: FFmpegCommandsProvider
) : MovieCreator {
    private val isCreating = AtomicBoolean(false)
    private val numberFormatter = NumberFormatter()

    override fun createMovie(
        outputDir: String,
        scenesDir: String
    ): MovieCreatorResult = run {
        if (isCreating.get()) {
            return@run MovieCreatorResult.Error("Can't create several movies simultaneously")
        }
        isCreating.set(true)

        val info = infoProvider.provideInfo(outputDir)

        val movieResultCode = ffmpegProvider.execute(
            ffmpegCommandsProvider.createMovieCommand(scenesDir, info.moviePath)
        )
        if (movieResultCode != ffmpegProvider.returnCodeSuccess) {
            isCreating.set(false)
            return@run MovieCreatorResult.Error("Failed to create a movie.")
        }

        val thumbTime = numberFormatter.formatMilliseconds(
            THUMB_TIME_FORMAT,
            ffmpegProvider.getMovieDuration(info.moviePath) / 2
        )
        val thumbResultCode = ffmpegProvider.execute(
            ffmpegCommandsProvider.createThumbCommand(info.moviePath, thumbTime, info.thumbPath)
        )
        if (thumbResultCode != ffmpegProvider.returnCodeSuccess) {
            isCreating.set(false)
            return@run MovieCreatorResult.Error("Failed to create a thumb.")
        }

        isCreating.set(false)
        MovieCreatorResult.Success(
            thumb = info.thumbPath,
            movie = info.moviePath
        )
    }

    override fun dispose() {
        if (isCreating.compareAndSet(true, false)) {
            ffmpegProvider.cancel()
        }
    }
}
