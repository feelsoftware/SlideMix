@file:JvmName("MoviesRepositoryChannelJava")
package com.vitoksmile.cpmoviemaker.channel

import com.vitoksmile.cpmoviemaker.repository.MoviesRepository

fun provideMoviesRepositoryChannel(
    repository: MoviesRepository
): MoviesRepositoryChannel = MoviesRepositoryChannelImpl(repository)
