@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker.channel

import com.vitoksmile.cpmoviemaker.repository.MoviesRepository
import kotlin.native.concurrent.freeze

fun provideMoviesRepositoryChannel(
    repository: MoviesRepository
): MoviesRepositoryChannel = MoviesRepositoryChannelImpl(repository).freeze()
