@file:JvmName("MovieCreatorChannelJava")

package com.vitoksmile.cpmoviemaker.channel

import com.vitoksmile.cpmoviemaker.MovieCreator
import com.vitoksmile.cpmoviemaker.provideMovieCreator
import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.MovieInfoProvider
import com.vitoksmile.cpmoviemaker.provider.provideMovieInfoProvider

fun provideMovieCreatorChannel(
    ffmpegProvider: FFmpegProvider,
    infoProvider: MovieInfoProvider = provideMovieInfoProvider(),
    movieCreator: MovieCreator = provideMovieCreator(infoProvider, ffmpegProvider)
): MovieCreatorChannel = MovieCreatorChannelImpl(movieCreator)
