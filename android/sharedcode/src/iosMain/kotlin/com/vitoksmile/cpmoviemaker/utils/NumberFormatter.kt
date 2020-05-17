package com.vitoksmile.cpmoviemaker.utils

import platform.Foundation.*

actual class NumberFormatter actual constructor() {
    actual fun formatMilliseconds(format: String, value: Long): String {
        val formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.timeZoneForSecondsFromGMT(0)
        formatter.dateFormat = format
        val date = NSDate(value.toDouble() / 1000)
        return formatter.stringFromDate(date)
    }
}
