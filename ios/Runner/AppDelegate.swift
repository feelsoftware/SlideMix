import UIKit
import Flutter

import mobileffmpeg

let CREATION_CHANNEL = "com.vitoksmile.cpmoviemaker.CREATION_CHANNEL"
let CREATION_METHOD_CREATE = "CREATION_METHOD_CREATE"
let CREATION_METHOD_CANCEL = "CREATION_METHOD_CANCEL"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    registerFFmpegChannel(controller: controller)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func registerFFmpegChannel(controller : FlutterViewController) {
        let channel = FlutterMethodChannel(name: CREATION_CHANNEL, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
            case CREATION_METHOD_CREATE:
                guard let list = call.arguments as? [String] else {
                    result(FlutterError(code: "ERROR", message: "Invalid type of arguments, must be [String].", details: nil));
                    return
                }
                if (list.capacity != 2) {
                    result(FlutterError(code: "ERROR", message: "Invalid count of arguments, must be 2: outputDir and scenesDir.", details: nil));
                    return
                }
                
                self.createMovie(outputDir: list[0], scenesDir: list[1], result: result)
                break;
            case CREATION_METHOD_CANCEL:
                self.cancelCreation(result: result)
                break;
            default:
                break;
            }
        })
    }
    
    private func createMovie(outputDir:String, scenesDir:String, result: @escaping FlutterResult) {
        DispatchQueue(label: "ffmpeg", qos: .utility).async {
            let moviePath = self.generateMovieName(dir: outputDir)
            if (moviePath == nil) {
                result(FlutterError(code: "ERROR", message: "Failed to generate movie's name.", details: nil))
                return
            }
            let resultCode = MobileFFmpeg.execute(withArguments: [
                "-framerate", "1",
                "-i", "\(scenesDir)/image%03d.jpg",
                "-r", "30",
                "-pix_fmt","yuv420p",
                "-y", moviePath
            ])
            switch resultCode {
            case RETURN_CODE_SUCCESS:
                result(moviePath)
                break;
            case RETURN_CODE_CANCEL:
                result(FlutterError(code: "ERROR", message: "Canceled by user.", details: nil))
                break;
            default:
                result(FlutterError(code: "ERROR", message: "Command execution failed.", details: nil))
                break;
            }
        }
    }
    
    private func cancelCreation(result: @escaping FlutterResult) {
        MobileFFmpeg.cancel()
        result(1)
    }
    
    private func generateMovieName(dir: String) -> String? {
        var name = self.generateMovieName()
        let files: [String]
        
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: dir)
        } catch {
            return nil
        }
        
        while files.contains(name) {
            name = self.generateMovieName()
        }
        
        return "\(dir)/\(name)"
    }
    
    private func generateMovieName() -> String {
        return "\(UUID.init().uuidString).mp4"
    }
}
