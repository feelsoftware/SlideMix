import UIKit
import Flutter

let CREATION_CHANNEL = "com.vitoksmile.cpmoviemaker.CREATION_CHANNEL"
let CREATION_METHOD_CREATE = "CREATION_METHOD_CREATE"
let CREATION_METHOD_CANCEL = "CREATION_METHOD_CANCEL"

let CREATION_RESULT_KEY_THUMB = "CREATION_RESULT_KEY_THUMB"
let CREATION_RESULT_KEY_MOVIE = "CREATION_RESULT_KEY_MOVIE"

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // TODO: use DI
    private var infoProvider: MovieInfoProvider!
    private var creator: MovieCreator!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.infoProvider = MovieInfoProviderImpl()
    self.creator = MovieCreatorImpl(infoProvider: self.infoProvider)
    
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
    
    private func createMovie(outputDir: String, scenesDir: String, result: @escaping FlutterResult) {
        DispatchQueue(label: "ffmpeg", qos: .utility).async {
            let creationResult = self.creator.createMovie(outputDir: outputDir, scenesDir: scenesDir)
            
            if creationResult is MovieCreatorResultSuccess {
                let success = (creationResult as! MovieCreatorResultSuccess)
                            
                var map = [String: String]()
                map[CREATION_RESULT_KEY_THUMB] = success.thumb
                map[CREATION_RESULT_KEY_MOVIE] = success.movie
                result(map)
            } else if creationResult is MovieCreatorResultError {
                let error = (creationResult as! MovieCreatorResultError)
                result(FlutterError(code: "ERROR", message: error.message, details: nil));
            }
        }
    }
    
    private func cancelCreation(result: @escaping FlutterResult) {
        self.creator.dispose()
        result(1)
    }
}
