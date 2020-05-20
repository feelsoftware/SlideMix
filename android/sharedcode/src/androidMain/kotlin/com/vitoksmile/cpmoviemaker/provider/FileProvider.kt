package com.vitoksmile.cpmoviemaker.provider

actual object FileProvider {
    actual val pathSeparator: String get() = java.io.File.separator
    actual val dotSeparator get() = "."
}

actual fun File.listFiles(): List<File> {
    val list = java.io.File(path).listFiles() ?: emptyArray()
    return list.map {
        File(it.path)
    }
}
