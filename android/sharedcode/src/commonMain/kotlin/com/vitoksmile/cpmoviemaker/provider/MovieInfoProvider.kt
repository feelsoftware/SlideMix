package com.vitoksmile.cpmoviemaker.provider

import com.vitoksmile.cpmoviemaker.model.Format
import com.vitoksmile.cpmoviemaker.model.UUID

interface MovieInfoProvider {
    fun provideInfo(outputDir: String): Info

    data class Info(
        val moviePath: String,
        val thumbPath: String
    )
}

object MovieInfoProviderImpl : MovieInfoProvider {
    override fun provideInfo(outputDir: String): MovieInfoProvider.Info {
        var uuid = generateUUID()
        val files = File(outputDir).listFiles().map { it.name }
        while (files.any { it.contains(uuid) }) {
            uuid = generateUUID()
        }

        return MovieInfoProvider.Info(
            moviePath = createPath(outputDir, uuid, Format.Movie.value),
            thumbPath = createPath(outputDir, uuid, Format.Thumb.value)
        )
    }

    private fun generateUUID() = UUID().toString()

    private fun createPath(outputDir: String, uuid: String, format: String) = buildString {
        append(outputDir)
        append(FileProvider.pathSeparator)
        append(uuid)
        append(FileProvider.dotSeparator)
        append(format)
    }
}
