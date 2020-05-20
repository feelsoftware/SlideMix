package com.vitoksmile.cpmoviemaker.repository

import com.squareup.sqldelight.db.SqlDriver
import com.vitoksmile.cpmoviemaker.repository.datasource.MoviesDBDataSource
import com.vitoksmile.cpmoviemaker.repository.datasource.provideMoviesDBDataSource

fun provideMoviesRepository(
    sqlDriver: SqlDriver,
    dbDataSource: MoviesDBDataSource = provideMoviesDBDataSource(sqlDriver)
): MoviesRepository = MoviesRepositoryImpl(dbDataSource)
