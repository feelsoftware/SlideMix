import UIKit
import Flutter
import SharedCode

let CHANNEL = "com.vitoksmile.cpmoviemaker.CHANNEL"
let METHOD_CREATE = "METHOD_CREATE"
let METHOD_CANCEL = "METHOD_CANCEL"
let METHOD_PROGRESS = "METHOD_PROGRESS"
let METHOD_READY = "METHOD_READY"
let METHOD_ERROR = "METHOD_ERROR"

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
        //result(String(call.method));
        result(MovieCreatorKt.platformName());
        switch call.method {
        case METHOD_CREATE:
            let list = call.arguments as! [String]
            print(list)
            break;
        default:
            break;
        }
    })
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
