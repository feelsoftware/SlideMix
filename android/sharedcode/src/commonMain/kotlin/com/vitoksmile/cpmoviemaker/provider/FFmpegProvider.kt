@file:Suppress("PropertyName")

package com.vitoksmile.cpmoviemaker.provider

interface FFmpegProvider {
    val returnCodeSuccess: Int
    val returnCodeCancel: Int

    fun execute(arguments: List<String>): Int

    fun cancel()
}
