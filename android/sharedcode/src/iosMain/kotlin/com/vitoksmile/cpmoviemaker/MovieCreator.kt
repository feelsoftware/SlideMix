@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider
import kotlin.native.concurrent.freeze

fun provideMovieCreator(
    infoProvider: MovieInfoProvider,
    ffmpegProvider: FFmpegProvider
): MovieCreator = MovieCreatorImpl(infoProvider, ffmpegProvider).freeze()
