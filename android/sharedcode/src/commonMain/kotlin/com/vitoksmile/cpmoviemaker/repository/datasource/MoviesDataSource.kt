package com.vitoksmile.cpmoviemaker.repository.datasource

import com.vitoksmile.cpmoviemaker.model.Movie

interface MoviesDataSource {
    fun getAll(): List<Movie>

    fun get(id: Long): Movie

    fun insert(title: String, thumb: String, video: String): Movie

    fun delete(id: Long)

    fun count(): Long
}
