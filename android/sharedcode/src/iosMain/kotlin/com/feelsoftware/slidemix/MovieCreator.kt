@file:Suppress("unused")

package com.feelsoftware.slidemix

import com.feelsoftware.slidemix.provider.FFmpegCommandsProvider
import com.feelsoftware.slidemix.provider.FFmpegProvider
import com.feelsoftware.slidemix.provider.MovieInfoProvider
import kotlin.native.concurrent.freeze

fun provideMovieCreator(
    infoProvider: MovieInfoProvider,
    ffmpegProvider: FFmpegProvider,
    ffmpegCommandsProvider: FFmpegCommandsProvider
): MovieCreator = MovieCreatorImpl(infoProvider, ffmpegProvider, ffmpegCommandsProvider).freeze()
