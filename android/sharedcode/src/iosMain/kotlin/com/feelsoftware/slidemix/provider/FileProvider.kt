package com.feelsoftware.slidemix.provider

import platform.Foundation.NSFileManager

actual object FileProvider {
    actual val pathSeparator get() = "/"
    actual val dotSeparator get() = "."
}

actual fun File.listFiles(): List<File> {
    val list = NSFileManager.defaultManager.contentsOfDirectoryAtPath(path = path, error = null)
        ?: emptyList<Any>()
    print(list)
    return emptyList()
}
