@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker.channel

import com.vitoksmile.cpmoviemaker.repository.MoviesRepository

private const val METHOD_GET_ALL = "getAll"
private const val METHOD_GET = "get"
private const val METHOD_INSERT = "insert"
private const val METHOD_DELETE = "delete"
private const val METHOD_COUNT = "count"

private const val KEY_ID = "id"
private const val KEY_TITLE = "title"
private const val KEY_THUMB = "thumb"
private const val KEY_VIDEO = "video"

interface MoviesRepositoryChannel : ChannelInteraction {
    companion object {
        const val CHANNEL = "com.vitoksmile.cpmoviemaker.MoviesRepositoryChannel"
    }
}

class MoviesRepositoryChannelImpl(
    private val repository: MoviesRepository
) : MoviesRepositoryChannel, ChannelInteractionImpl() {
    override suspend fun run(method: String, arguments: Map<String, Any>): String {
        return when (method) {
            METHOD_GET_ALL -> {
                repository.getAll()
            }
            METHOD_GET -> {
                val id = arguments.getValue(KEY_ID) as Long
                repository.get(id)
            }
            METHOD_INSERT -> {
                val title = arguments.getValue(KEY_TITLE) as String
                val thumb = arguments.getValue(KEY_THUMB) as String
                val video = arguments.getValue(KEY_VIDEO) as String
                repository.insert(title, thumb, video)
            }
            METHOD_DELETE -> {
                val id = arguments.getValue(KEY_ID) as Long
                repository.delete(id)
                emptyResult
            }
            METHOD_COUNT -> {
                repository.count().toString()
            }
            else -> unsupportedMethod(method, arguments)
        }
    }
}
