@file:Suppress("unused")

package com.feelsoftware.slidemix.channel

import co.touchlab.stately.freeze
import com.feelsoftware.slidemix.provideMovieCreator
import com.feelsoftware.slidemix.provider.FFmpegProvider
import com.feelsoftware.slidemix.provider.provideFFmpegCommandsProvider
import com.feelsoftware.slidemix.provider.provideMovieInfoProvider

fun provideMovieCreatorChannel(
    ffmpegProvider: FFmpegProvider
): MovieCreatorChannel = MovieCreatorChannelImpl(
    movieCreator = provideMovieCreator(
        infoProvider = provideMovieInfoProvider(),
        ffmpegProvider = ffmpegProvider,
        ffmpegCommandsProvider = provideFFmpegCommandsProvider()
    )
).freeze()
