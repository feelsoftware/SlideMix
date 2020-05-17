package com.vitoksmile.cpmoviemaker.utils

expect class NumberFormatter() {
    fun formatMilliseconds(format: String, value: Long): String
}
