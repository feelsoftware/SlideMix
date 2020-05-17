package com.vitoksmile.cpmoviemaker.provider

import com.arthenica.mobileffmpeg.Config
import com.arthenica.mobileffmpeg.FFmpeg
import com.arthenica.mobileffmpeg.FFprobe

class FFmpegProviderImpl : FFmpegProvider {
    override val returnCodeSuccess get() = Config.RETURN_CODE_SUCCESS
    override val returnCodeCancel get() = Config.RETURN_CODE_CANCEL

    override fun execute(arguments: List<String>): Int {
        return FFmpeg.execute(arguments.toTypedArray())
    }

    override fun getMovieDuration(path: String): Long {
        return FFprobe.getMediaInformation(path).duration
    }

    override fun cancel() {
        FFmpeg.cancel()
    }
}
