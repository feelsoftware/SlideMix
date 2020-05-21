@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker.channel

import co.touchlab.stately.freeze
import com.vitoksmile.cpmoviemaker.provideMovieCreator
import com.vitoksmile.cpmoviemaker.provider.FFmpegProvider
import com.vitoksmile.cpmoviemaker.provider.provideMovieInfoProvider

fun provideMovieCreatorChannel(
    ffmpegProvider: FFmpegProvider
): MovieCreatorChannel = MovieCreatorChannelImpl(
    movieCreator = provideMovieCreator(
        infoProvider = provideMovieInfoProvider(),
        ffmpegProvider = ffmpegProvider
    )
).freeze()
