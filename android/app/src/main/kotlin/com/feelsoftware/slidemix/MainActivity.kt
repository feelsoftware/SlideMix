package com.feelsoftware.slidemix

import com.feelsoftware.slidemix.capability.VideoCapabilityMethodChannel
import com.feelsoftware.slidemix.ffmpeg.FFmpegMethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FFmpegMethodChannel.attach(flutterEngine)
        VideoCapabilityMethodChannel.attach(flutterEngine)
    }
}
