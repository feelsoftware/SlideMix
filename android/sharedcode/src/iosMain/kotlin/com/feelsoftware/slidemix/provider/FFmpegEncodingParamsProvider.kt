package com.feelsoftware.slidemix.provider

import com.feelsoftware.slidemix.model.FFmpegEncodingParams

actual class FFmpegEncodingParamsProvider actual constructor() {
    /**
     * No need to scale the resulted video.
     */
    actual fun provideParams() = FFmpegEncodingParams(resolution = null)
}
