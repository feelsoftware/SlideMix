package com.feelsoftware.slidemix.model

expect sealed class Format constructor(value: String) {
    val value: String

    object Movie : Format

    object Thumb : Format
}