package com.vitoksmile.cpmoviemaker.model

actual sealed class Format actual constructor(
    actual val value: String
) {
    actual object Movie : Format("mp4")

    actual object Thumb : Format("jpg")
}
