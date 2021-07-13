@file:JvmName("MoviesRepositoryChannelJava")
package com.feelsoftware.slidemix.channel

import com.feelsoftware.slidemix.repository.MoviesRepository

fun provideMoviesRepositoryChannel(
    repository: MoviesRepository
): MoviesRepositoryChannel = MoviesRepositoryChannelImpl(repository)
