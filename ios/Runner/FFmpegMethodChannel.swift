import Flutter
import ffmpegkit

class FFmpegMethodChannel : NSObject, FlutterPlugin, FlutterStreamHandler {
    
    func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            
        case FFmpegMethodChannel.METHOD_EXECUTE:
            do {
                let arguments = call.arguments as! [String]
                
                let session = FFmpegSession.create(arguments)!
                FFmpegKitConfig.ffmpegExecute(session)
                
                var logs: String?
                if session.getReturnCode().isValueError() {
                    logs = session.getLogs().reversed().map { String(describing: $0) }.joined(separator: ", ")
                }
                let returnCode = FFmpegReturnCode(
                    isSuccess: session.getReturnCode().isValueSuccess(),
                    isCancel: session.getReturnCode().isValueCancel(),
                    isError: session.getReturnCode().isValueError(),
                    logs: logs
                )
                let json = String(data: try JSONEncoder().encode(returnCode), encoding: .utf8)!
                result(json)
            } catch {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: error))
            }
            break
            
        case FFmpegMethodChannel.METHOD_DURATION:
            do {
                let path = call.arguments as! String
                let mediaInformation = FFprobeKit.getMediaInformation(path).getMediaInformation()!
                let duration = NumberFormatter().number(from: mediaInformation.getDuration())?.doubleValue ?? 0.0
                result(duration)
            } catch {
                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: error))
            }
            break
            
        case FFmpegMethodChannel.METHOD_DISPOSE:
            FFmpegKit.cancel()
            result(true)
            break
            
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        let duration = (arguments as? Int).flatMap { max(Double($0), 0.1) } ?? 1.0
        FFmpegKitConfig.enableStatisticsCallback { statistic in
            let progress = min(max((statistic?.getTime() ?? 0.0) / duration, 0.0), 1.0)
            DispatchQueue.main.async { events(progress) }
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        FFmpegKitConfig.enableStatisticsCallback {_ in }
        return nil
    }
    
    private static let NAME = "com.feelsoftware.slidemix.ffmpeg"
    private static let NAME_PROGRESS = "com.feelsoftware.slidemix.ffmpeg.progress"
    
    private static let METHOD_EXECUTE = "execute"
    private static let METHOD_DURATION = "duration"
    private static let METHOD_DISPOSE = "dispose"
    
    static func register(with registry: FlutterPluginRegistry) {
        let registrar = registry.registrar(forPlugin: FFmpegMethodChannel.NAME)
        if let safeRegistrar = registrar {
            register(with: safeRegistrar)
        }
    }
    
    static func register(with registrar: FlutterPluginRegistrar) {
        let taskQueue = registrar.messenger().makeBackgroundTaskQueue!()
        let instance = FFmpegMethodChannel()
        registrar.addMethodCallDelegate(
            instance,
            channel: FlutterMethodChannel(
                name: FFmpegMethodChannel.NAME,
                binaryMessenger: registrar.messenger(),
                codec: FlutterStandardMethodCodec.sharedInstance(),
                taskQueue: taskQueue
            )
        )
        FlutterEventChannel(
            name: FFmpegMethodChannel.NAME_PROGRESS,
            binaryMessenger: registrar.messenger(),
            codec: FlutterStandardMethodCodec.sharedInstance(),
            taskQueue: taskQueue
        ).setStreamHandler(instance)
    }
    
}

private struct FFmpegReturnCode : Codable {
    let isSuccess : Bool
    let isCancel : Bool
    let isError : Bool
    let logs : String?
}
