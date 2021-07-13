package com.feelsoftware.slidemix.provider

import com.feelsoftware.slidemix.model.FFmpegEncodingParams

/**
 * @see <a href="https://developer.android.com/guide/topics/media/media-formats.html#video-encoding">Video encoding recommendations</a>
 */
actual class FFmpegEncodingParamsProvider actual constructor() {
    /**
     * Scale the resulted video due to the next exception:
     * DecoderInitializationException: Decoder init failed:
     * OMX.qcom.video.decoder.mpeg4, Format(1, null, null, video/mp4v-es, null, -1, null, [1920, 2560, -1.0], [-1, -1])
     */
    actual fun provideParams(): FFmpegEncodingParams {
        return FFmpegEncodingParams(
            resolution = FFmpegEncodingParams.Resolution(
                width = 1280,
                height = 720
            )
        )
    }
}
