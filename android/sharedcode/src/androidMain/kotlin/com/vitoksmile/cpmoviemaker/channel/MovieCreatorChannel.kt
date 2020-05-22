@file:JvmName("MovieCreatorChannelJava")

package com.vitoksmile.cpmoviemaker.channel

import com.vitoksmile.cpmoviemaker.MovieCreator
import com.vitoksmile.cpmoviemaker.provideMovieCreator
import com.vitoksmile.cpmoviemaker.provider.*

fun provideMovieCreatorChannel(
    ffmpegProvider: FFmpegProvider,
    ffmpegCommandsProvider: FFmpegCommandsProvider = provideFFmpegCommandsProvider(),
    infoProvider: MovieInfoProvider = provideMovieInfoProvider(),
    movieCreator: MovieCreator = provideMovieCreator(
        infoProvider = infoProvider,
        ffmpegProvider = ffmpegProvider,
        ffmpegCommandsProvider = ffmpegCommandsProvider
    )
): MovieCreatorChannel = MovieCreatorChannelImpl(movieCreator)
