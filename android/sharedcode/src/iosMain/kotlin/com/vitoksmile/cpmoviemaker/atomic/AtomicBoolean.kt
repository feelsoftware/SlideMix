package com.vitoksmile.cpmoviemaker.atomic

import kotlinx.atomicfu.atomic

actual class AtomicBoolean actual constructor(initialValue: Boolean) {
    private val value = atomic(initialValue)

    actual fun get() = value.value

    actual fun set(newValue: Boolean) {
        value.value = newValue
    }

    actual fun compareAndSet(expect: Boolean, update: Boolean) = value.compareAndSet(expect, update)
}
