package com.feelsoftware.slidemix.repository.datasource

import com.squareup.sqldelight.db.SqlDriver
import com.feelsoftware.slidemix.MoviesDB
import com.feelsoftware.slidemix.model.Movie

interface MoviesDBDataSource : MoviesDataSource

class MoviesDBDataSourceImpl(
    sqlDriver: SqlDriver
) : MoviesDBDataSource {
    private val moviesDB = MoviesDB(sqlDriver)

    override fun getAll() = moviesDB.moviesDBQueries.getAll().executeAsList().map {
        Movie(it.id, it.title, it.thumb, it.video)
    }

    override fun get(id: Long) = moviesDB.moviesDBQueries.get(id).executeAsOne().run {
        Movie(id, title, thumb, video)
    }

    override fun insert(title: String, thumb: String, video: String): Movie {
        moviesDB.moviesDBQueries.insert(title, thumb, video)
        val id = moviesDB.moviesDBQueries.lastInsertId().executeAsOne()
        return get(id)
    }

    override fun delete(id: Long) {
        moviesDB.moviesDBQueries.delete(id)
    }

    override fun count() = moviesDB.moviesDBQueries.count().executeAsOne()
}
