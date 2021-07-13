@file:Suppress("PropertyName")

package com.feelsoftware.slidemix.provider

interface FFmpegProvider {
    val returnCodeSuccess: Int
    val returnCodeCancel: Int

    /**
     * Synchronously executes FFmpeg with arguments provided.
     *
     * @param arguments FFmpeg command options/arguments as string array
     * @return [returnCodeSuccess] on successful execution, [returnCodeCancel] on user cancel and non-zero on error
     */
    fun execute(arguments: List<String>): Int

    /**
     * @return Duration of a movie by the [path] in milliseconds.
     */
    fun getMovieDuration(path: String): Long

    /**
     * Cancels an ongoing operation.
     */
    fun cancel()
}
