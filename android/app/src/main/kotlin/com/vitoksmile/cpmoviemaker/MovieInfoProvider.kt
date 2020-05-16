package com.vitoksmile.cpmoviemaker

import java.io.File
import java.util.*

interface MovieInfoProvider {
    fun provideInfo(outputDir: String): Info

    data class Info(
        val thumbPath: String,
        val moviePath: String
    )
}

class MovieInfoProviderImpl : MovieInfoProvider {
    override fun provideInfo(outputDir: String): MovieInfoProvider.Info {
        var uuid = generateUUID()
        val files = File(outputDir).listFiles().map { it.name }
        while (files.any { it.contains(uuid) }) {
            uuid = generateUUID()
        }

        return MovieInfoProvider.Info(
            thumbPath = createPath(outputDir, uuid, "jpg"),
            moviePath = createPath(outputDir, uuid, "mp4")
        )
    }

    private fun generateUUID() = UUID.randomUUID().toString()

    private fun createPath(outputDir: String, uuid: String, format: String) = buildString {
        append(outputDir)
        append(File.separator)
        append(uuid)
        append(".")
        append(format)
    }
}
