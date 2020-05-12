import UIKit
import Flutter

let CHANNEL = "com.vitoksmile.cpmoviemaker.CHANNEL"
let METHOD_CREATE = "METHOD_CREATE"
let METHOD_CANCEL = "METHOD_CANCEL"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        switch call.method {
        case METHOD_CREATE:
            guard let list = call.arguments as? [String] else {
                result(FlutterError(code: "ERROR", message: "Invalid type of arguments, must be List<String>.", details: nil));
                return
            }
            if (list.capacity != 2) {
                result(FlutterError(code: "ERROR", message: "Invalid count of arguments, must be 2: outputDir and scenesDir.", details: nil));
                return
            }
            let outputDir = list[0];
            let scenesDir = list[1];
            print("outputDir \(outputDir), scenesDir \(scenesDir)")
            break;
        default:
            break;
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
