@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker.repository

import com.vitoksmile.cpmoviemaker.repository.datasource.MoviesDBDataSource
import com.vitoksmile.cpmoviemaker.repository.datasource.provideMoviesDBDataSource
import kotlin.native.concurrent.freeze

fun provideMoviesRepository(
    dbDataSource: MoviesDBDataSource = provideMoviesDBDataSource()
): MoviesRepository = MoviesRepositoryImpl(dbDataSource).freeze()
