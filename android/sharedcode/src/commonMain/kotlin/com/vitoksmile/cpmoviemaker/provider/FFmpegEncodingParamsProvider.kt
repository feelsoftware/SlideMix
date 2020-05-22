package com.vitoksmile.cpmoviemaker.provider

import com.vitoksmile.cpmoviemaker.model.FFmpegEncodingParams

expect class FFmpegEncodingParamsProvider() {
    fun provideParams(): FFmpegEncodingParams
}
