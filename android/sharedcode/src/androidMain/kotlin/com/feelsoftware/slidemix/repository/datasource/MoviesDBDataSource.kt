package com.feelsoftware.slidemix.repository.datasource

import com.squareup.sqldelight.db.SqlDriver

fun provideMoviesDBDataSource(
    sqlDriver: SqlDriver
): MoviesDBDataSource = MoviesDBDataSourceImpl(sqlDriver)
