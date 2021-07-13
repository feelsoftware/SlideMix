package com.feelsoftware.slidemix.repository

import com.squareup.sqldelight.db.SqlDriver
import com.feelsoftware.slidemix.repository.datasource.MoviesDBDataSource
import com.feelsoftware.slidemix.repository.datasource.provideMoviesDBDataSource

fun provideMoviesRepository(
    sqlDriver: SqlDriver,
    dbDataSource: MoviesDBDataSource = provideMoviesDBDataSource(sqlDriver)
): MoviesRepository = MoviesRepositoryImpl(dbDataSource)
