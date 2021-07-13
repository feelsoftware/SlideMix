package com.feelsoftware.slidemix.utils

expect class NumberFormatter() {
    fun formatMilliseconds(format: String, value: Long): String
}
