@file:JvmName("MovieCreatorJava")

package com.vitoksmile.cpmoviemaker

import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider

fun provideMovieCreator(
    infoProvider: MovieInfoProvider,
    ffmpegProvider: FFmpegProvider
): MovieCreator = MovieCreatorImpl(infoProvider, ffmpegProvider)
