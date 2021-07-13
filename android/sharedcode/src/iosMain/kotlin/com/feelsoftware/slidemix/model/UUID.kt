package com.feelsoftware.slidemix.model

import platform.Foundation.NSUUID

actual class UUID {
    private val uuid = NSUUID()

    actual override fun toString() = uuid.UUIDString
}
