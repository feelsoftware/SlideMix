package com.vitoksmile.cpmoviemaker.model

data class FFmpegEncodingParams(
    val resolution: Resolution?
) {
    data class Resolution(
        val width: Int,
        val height: Int
    )
}
