package com.vitoksmile.cpmoviemaker.repository.datasource

import com.squareup.sqldelight.db.SqlDriver

fun provideMoviesDBDataSource(
    sqlDriver: SqlDriver
): MoviesDBDataSource = MoviesDBDataSourceImpl(sqlDriver)
