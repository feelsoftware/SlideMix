package com.vitoksmile.cpmoviemaker.provider

import com.vitoksmile.cpmoviemaker.model.FFmpegEncodingParams

actual class FFmpegEncodingParamsProvider actual constructor() {
    /**
     * No need to scale the resulted video.
     */
    actual fun provideParams() = FFmpegEncodingParams(resolution = null)
}
