package com.vitoksmile.cpmoviemaker.provider

expect object FileProvider {
    val pathSeparator: String
    val dotSeparator: String
}

class File(
    val path: String
) {
    val name: String get() = path.substringAfterLast(delimiter = FileProvider.pathSeparator)
}

expect fun File.listFiles(): List<File>
