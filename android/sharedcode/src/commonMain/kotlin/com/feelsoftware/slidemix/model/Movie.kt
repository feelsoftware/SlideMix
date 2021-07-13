package com.feelsoftware.slidemix.model

import com.feelsoftware.slidemix.MovieEntity
import kotlinx.serialization.Serializable

@Serializable
data class Movie(
    override val id: Long,
    override val title: String,
    override val thumb: String,
    override val video: String
) : MovieEntity
