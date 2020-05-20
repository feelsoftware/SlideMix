@file:Suppress("unused")

package com.vitoksmile.cpmoviemaker.channel

import com.vitoksmile.cpmoviemaker.coroutines.CoroutineDispatchers
import com.vitoksmile.cpmoviemaker.coroutines.onUI
import com.vitoksmile.cpmoviemaker.repository.MoviesRepository
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

private const val METHOD_GET_ALL = "getAll"
private const val METHOD_GET = "get"
private const val METHOD_INSERT = "insert"
private const val METHOD_DELETE = "delete"

private const val KEY_ID = "id"
private const val KEY_TITLE = "title"
private const val KEY_THUMB = "thumb"
private const val KEY_VIDEO = "video"

interface MoviesRepositoryChannel {
    companion object {
        const val CHANNEL = "com.vitoksmile.cpmoviemaker.MoviesRepositoryChannel"
    }

    fun methodCall(method: String, arguments: Map<String, Any>, result: (Any) -> Unit)

    fun dispose()
}

class MoviesRepositoryChannelImpl(
    private val repository: MoviesRepository
) : MoviesRepositoryChannel, CoroutineScope {
    private val exceptionHandler = CoroutineExceptionHandler { _, throwable ->
        println(throwable)
    }
    override val coroutineContext: CoroutineContext
        get() = SupervisorJob() + CoroutineDispatchers.Background + exceptionHandler

    override fun methodCall(method: String, arguments: Map<String, Any>, result: (Any) -> Unit) {
        launch {
            when (method) {
                METHOD_GET_ALL -> {
                    val movies = repository.getAll()
                    onUI { result(movies) }
                }
                METHOD_GET -> {
                    val id = arguments.getValue(KEY_ID) as Long
                    val movie = repository.get(id)
                    onUI { result(movie) }
                }
                METHOD_INSERT -> {
                    val title = arguments.getValue(KEY_TITLE) as String
                    val thumb = arguments.getValue(KEY_THUMB) as String
                    val video = arguments.getValue(KEY_VIDEO) as String
                    val movie = repository.insert(title, thumb, video)
                    onUI { result(movie) }
                }
                METHOD_DELETE -> {
                    val id = arguments.getValue(KEY_ID) as Long
                    repository.delete(id)
                    onUI { result(Unit) }
                }
            }
        }
    }

    override fun dispose() {
        coroutineContext.cancelChildren()
    }
}
