package com.feelsoftware.slidemix.channel

import com.feelsoftware.slidemix.coroutines.CoroutineDispatchers
import com.feelsoftware.slidemix.coroutines.onUI
import kotlinx.coroutines.*
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonConfiguration
import kotlin.coroutines.CoroutineContext

interface ChannelInteraction {
    fun methodCall(method: String, arguments: Map<String, Any>, result: (Any) -> Unit)

    fun dispose()
}

abstract class ChannelInteractionImpl : ChannelInteraction, CoroutineScope {
    private val exceptionHandler = CoroutineExceptionHandler { _, throwable ->
        println(throwable)
    }
    override val coroutineContext: CoroutineContext
        get() = SupervisorJob() + CoroutineDispatchers.Background + exceptionHandler

    protected val json: Json by lazy {
        Json(JsonConfiguration.Stable)
    }
    protected val emptyResult = "{}"

    abstract suspend fun run(method: String, arguments: Map<String, Any>): String

    override fun methodCall(method: String, arguments: Map<String, Any>, result: (Any) -> Unit) {
        launch {
            val data = run(method, arguments)
            onUI { result(data) }
        }
    }

    override fun dispose() {
        coroutineContext.cancelChildren()
    }

    protected fun unsupportedMethod(method: String, arguments: Map<String, Any>): Nothing =
        throw IllegalArgumentException("Unsupported method: $method, arguments: $arguments")
}
