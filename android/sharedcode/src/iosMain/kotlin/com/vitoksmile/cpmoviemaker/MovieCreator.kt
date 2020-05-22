@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.provider.FFmpegCommandsProvider
import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider
import kotlin.native.concurrent.freeze

fun provideMovieCreator(
    infoProvider: MovieInfoProvider,
    ffmpegProvider: FFmpegProvider,
    ffmpegCommandsProvider: FFmpegCommandsProvider
): MovieCreator = MovieCreatorImpl(infoProvider, ffmpegProvider, ffmpegCommandsProvider).freeze()
