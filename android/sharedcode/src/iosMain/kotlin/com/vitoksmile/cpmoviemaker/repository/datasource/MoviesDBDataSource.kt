package com.vitoksmile.cpmoviemaker.repository.datasource

import com.squareup.sqldelight.db.SqlDriver
import com.squareup.sqldelight.drivers.native.NativeSqliteDriver
import com.vitoksmile.cpmoviemaker.MoviesDB
import kotlin.native.concurrent.freeze

private val moviesSqlDriver: SqlDriver = NativeSqliteDriver(MoviesDB.Schema, "movies.db")

fun provideMoviesDBDataSource(): MoviesDBDataSource = MoviesDBDataSourceImpl(
    moviesSqlDriver
).freeze()
