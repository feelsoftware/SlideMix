package com.vitoksmile.cpmoviemaker.coroutines

import kotlinx.coroutines.Dispatchers
import kotlin.coroutines.CoroutineContext

actual object CoroutineDispatchers {
    actual val Main: CoroutineContext = Dispatchers.Main

    actual val Background: CoroutineContext = Dispatchers.IO

}
