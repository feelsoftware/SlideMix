@file:Suppress("DEPRECATION")

package com.feelsoftware.slidemix.capability

import android.media.MediaCodecInfo
import android.media.MediaCodecList
import android.util.Range
import androidx.annotation.WorkerThread
import kotlinx.serialization.Serializable
import kotlin.math.roundToInt

class VideoCapabilityProvider {

    private val supportedVideoResolutions = arrayOf(
        640 to 480,
        1280 to 720,
        1920 to 1080,
        2560 to 1440,
        2048 to 1080,
        3840 to 2160,
        7680 to 4120,
    )

    @WorkerThread
    fun getVideoCapabilities(): List<VideoCapability> {
        val result = mutableListOf<VideoCapability>()

        for (i in 0 until MediaCodecList.getCodecCount()) {
            val info = MediaCodecList.getCodecInfoAt(i)
            if (!info.isEncoder) continue

            val types = info.supportedTypes.toList()
            if (types.none { it.contains("video/") }) continue

            for (type in types) {
                val sizes = mutableListOf<VideoSize?>()

                val videoCapabilities = info.getCapabilitiesForType(type).videoCapabilities
                val supportedHeights = videoCapabilities.supportedHeights

                supportedVideoResolutions.forEach { (width, height) ->
                    sizes += calculateSize(videoCapabilities, supportedHeights, width, height)
                }
                if (sizes.filterNotNull().isEmpty()) continue

                result += VideoCapability(
                    mime = type,
                    sizes = sizes.filterNotNull(),
                )
            }
        }

        return result
    }

    private fun calculateSize(
        videoCapabilities: MediaCodecInfo.VideoCapabilities,
        supportedHeights: Range<Int>,
        width: Int,
        height: Int,
    ): VideoSize? {
        return if (
            supportedHeights.contains(height) &&
            videoCapabilities.getSupportedWidthsFor(height).contains(width)
        ) {
            VideoSize(
                width = width,
                height = height,
                fps = videoCapabilities.getSupportedFrameRatesFor(width, height).upper.roundToInt()
                    .coerceAtMost(60),
            )
        } else {
            null
        }
    }
}

@Serializable
data class VideoCapability(
    val mime: String,
    val sizes: List<VideoSize>,
)

@Serializable
data class VideoSize(
    val width: Int,
    val height: Int,
    val fps: Int,
)