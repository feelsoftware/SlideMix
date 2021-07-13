@file:Suppress("unused")

package com.feelsoftware.slidemix.repository

import com.feelsoftware.slidemix.repository.datasource.MoviesDBDataSource
import com.feelsoftware.slidemix.repository.datasource.provideMoviesDBDataSource
import kotlin.native.concurrent.freeze

fun provideMoviesRepository(
    dbDataSource: MoviesDBDataSource = provideMoviesDBDataSource()
): MoviesRepository = MoviesRepositoryImpl(dbDataSource).freeze()
