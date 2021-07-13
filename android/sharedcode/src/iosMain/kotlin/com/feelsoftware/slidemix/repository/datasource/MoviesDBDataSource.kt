package com.feelsoftware.slidemix.repository.datasource

import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.native.NativeSqliteDriver
import com.feelsoftware.slidemix.MoviesDB
import kotlin.native.concurrent.freeze

private val moviesSqlDriver: SqlDriver = NativeSqliteDriver(MoviesDB.Schema, "movies.db")

fun provideMoviesDBDataSource(): MoviesDBDataSource = MoviesDBDataSourceImpl(
    moviesSqlDriver
).freeze()
