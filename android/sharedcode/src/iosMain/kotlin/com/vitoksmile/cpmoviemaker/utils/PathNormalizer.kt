package com.vitoksmile.cpmoviemaker.utils

actual fun String.normalizePath() = replace("\\s+".toRegex(), "%20")
