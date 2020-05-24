@file:Suppress("BooleanLiteralArgument")

package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.atomic.AtomicBoolean
import com.vitoksmile.cpmoviemaker.model.MovieCreatorResult
import com.vitoksmile.cpmoviemaker.provider.FFmpegCommandsProvider
import com.vitoksmile.cpmoviemaker.provider.FFmpegCommandsProvider.Companion.THUMB_TIME_FORMAT
import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider
import com.vitoksmile.cpmoviemaker.utils.NumberFormatter

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
