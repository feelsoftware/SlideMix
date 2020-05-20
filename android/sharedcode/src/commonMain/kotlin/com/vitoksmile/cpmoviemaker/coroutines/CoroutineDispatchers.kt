package com.vitoksmile.cpmoviemaker.coroutines

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.withContext
import kotlin.coroutines.CoroutineContext

expect object CoroutineDispatchers {
    val Main: CoroutineContext

    val Background: CoroutineContext
}

suspend fun <T> onUI(
    block: suspend CoroutineScope.() -> T
): T = withContext(CoroutineDispatchers.Main, block = block)
