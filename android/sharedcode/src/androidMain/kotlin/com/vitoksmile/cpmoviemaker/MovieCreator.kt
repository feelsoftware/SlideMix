@file:JvmName("MovieCreatorJava")

package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.provider.FFmpegCommandsProvider
import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider

fun provideMovieCreator(
    infoProvider: MovieInfoProvider,
    ffmpegProvider: FFmpegProvider,
    ffmpegCommandsProvider: FFmpegCommandsProvider
): MovieCreator = MovieCreatorImpl(infoProvider, ffmpegProvider, ffmpegCommandsProvider)
