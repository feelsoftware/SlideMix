package com.feelsoftware.slidemix.provider

import com.feelsoftware.slidemix.model.FFmpegEncodingParams

expect class FFmpegEncodingParamsProvider() {
    fun provideParams(): FFmpegEncodingParams
}
