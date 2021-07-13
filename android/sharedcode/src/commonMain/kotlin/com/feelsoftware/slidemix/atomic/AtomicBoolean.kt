package com.feelsoftware.slidemix.atomic

expect class AtomicBoolean(initialValue: Boolean) {
    fun get(): Boolean

    fun set(newValue: Boolean)

    fun compareAndSet(expect: Boolean, update: Boolean): Boolean
}
