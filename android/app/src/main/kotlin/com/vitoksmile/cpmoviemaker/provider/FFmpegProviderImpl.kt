package com.vitoksmile.cpmoviemaker.provider

import com.arthenica.mobileffmpeg.Config
import com.arthenica.mobileffmpeg.FFmpeg

class FFmpegProviderImpl : FFmpegProvider {
    override val returnCodeSuccess get() = Config.RETURN_CODE_SUCCESS
    override val returnCodeCancel get() = Config.RETURN_CODE_CANCEL

    override fun execute(arguments: List<String>): Int {
        return FFmpeg.execute(arguments.toTypedArray())
    }

    override fun cancel() {
        FFmpeg.cancel()
    }
}
