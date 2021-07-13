package com.feelsoftware.slidemix.model

import kotlinx.serialization.Serializable

@Serializable
sealed class MovieCreatorResult {
    @Serializable
    data class Success(
        val thumb: String,
        val movie: String
    ) : MovieCreatorResult()

    @Serializable
    data class Error(
        val message: String
    ) : MovieCreatorResult()
}
