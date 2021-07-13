package com.feelsoftware.slidemix.atomic

import java.util.concurrent.atomic.AtomicBoolean

actual class AtomicBoolean actual constructor(initialValue: Boolean) {
    private val value = AtomicBoolean(initialValue)

    actual fun get() = value.get()

    actual fun set(newValue: Boolean) {
        value.set(newValue)
    }

    actual fun compareAndSet(expect: Boolean, update: Boolean) = value.compareAndSet(expect, update)
}
