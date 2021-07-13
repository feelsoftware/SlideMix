@file:Suppress("unused")

package com.feelsoftware.slidemix.channel

import com.feelsoftware.slidemix.repository.MoviesRepository
import kotlin.native.concurrent.freeze

fun provideMoviesRepositoryChannel(
    repository: MoviesRepository
): MoviesRepositoryChannel = MoviesRepositoryChannelImpl(repository).freeze()
