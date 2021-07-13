package com.feelsoftware.slidemix.channel

import com.feelsoftware.slidemix.MovieCreator
import com.feelsoftware.slidemix.model.MovieCreatorResult

private const val METHOD_CREATE = "METHOD_CREATE"
private const val METHOD_CANCEL = "METHOD_CANCEL"

private const val KEY_OUTPUT_DIR = "KEY_OUTPUT_DIR"
private const val KEY_SCENES_DIR = "KEY_SCENES_DIR"

interface MovieCreatorChannel : ChannelInteraction {
    companion object {
        const val CHANNEL = "com.feelsoftware.slidemix.MovieCreatorChannel"
    }
}

class MovieCreatorChannelImpl(
    private val movieCreator: MovieCreator
) : MovieCreatorChannel, ChannelInteractionImpl() {
    override suspend fun run(method: String, arguments: Map<String, Any>): String {
        return when (method) {
            METHOD_CREATE -> {
                val result = movieCreator.createMovie(
                    outputDir = arguments.getValue(KEY_OUTPUT_DIR) as String,
                    scenesDir = arguments.getValue(KEY_SCENES_DIR) as String
                )
                json.stringify(MovieCreatorResult.serializer(), result)
            }
            METHOD_CANCEL -> {
                movieCreator.dispose()
                emptyResult
            }
            else -> unsupportedMethod(method, arguments)
        }
    }

    override fun dispose() {
        super.dispose()
        movieCreator.dispose()
    }
}
