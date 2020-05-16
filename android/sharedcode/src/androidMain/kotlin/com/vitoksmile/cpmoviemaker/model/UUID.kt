package com.vitoksmile.cpmoviemaker.model

import java.util.UUID

actual class UUID {
    private val uuid = UUID.randomUUID()

    actual override fun toString() = uuid.toString()
}
