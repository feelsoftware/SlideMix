package com.feelsoftware.slidemix

import com.feelsoftware.slidemix.capability.VideoCapabilityMethodChannel
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        VideoCapabilityMethodChannel.attach(flutterEngine)
    }
}
