@file:JvmName("MovieCreatorChannelJava")

package com.feelsoftware.slidemix.channel

import com.feelsoftware.slidemix.MovieCreator
import com.feelsoftware.slidemix.provideMovieCreator
import com.feelsoftware.slidemix.provider.*

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
