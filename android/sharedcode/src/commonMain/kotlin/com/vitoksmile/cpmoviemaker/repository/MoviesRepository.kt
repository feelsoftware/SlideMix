package com.vitoksmile.cpmoviemaker.repository

import com.vitoksmile.cpmoviemaker.model.Movie
import com.vitoksmile.cpmoviemaker.repository.datasource.MoviesDBDataSource
import kotlinx.serialization.builtins.list
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration

interface MoviesRepository {
    fun getAll(): String

    fun get(id: Long): String

    fun insert(title: String, thumb: String, video: String): String

    fun delete(id: Long)
}

class MoviesRepositoryImpl(
    private val dbDataSource: MoviesDBDataSource
) : MoviesRepository {
    private val json: Json by lazy {
        Json(JsonConfiguration.Stable)
    }

    override fun getAll(): String {
        val movies = dbDataSource.getAll()
        return json.stringify(Movie.serializer().list, movies)
    }

    override fun get(id: Long): String {
        val movie = dbDataSource.get(id)
        return json.stringify(Movie.serializer(), movie)
    }

    override fun insert(title: String, thumb: String, video: String): String {
        val movie = dbDataSource.insert(title, thumb, video)
        return json.stringify(Movie.serializer(), movie)
    }

    override fun delete(id: Long): Unit = dbDataSource.delete(id)
}
