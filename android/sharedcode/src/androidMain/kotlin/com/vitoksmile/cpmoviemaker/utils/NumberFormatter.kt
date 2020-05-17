package com.vitoksmile.cpmoviemaker.utils

import java.text.SimpleDateFormat
import java.util.*

actual class NumberFormatter actual constructor() {
    actual fun formatMilliseconds(format: String, value: Long): String {
        val formatter = SimpleDateFormat(format, Locale.ENGLISH)
        formatter.timeZone = TimeZone.getTimeZone("UTC")
        return formatter.format(value)
    }
}
