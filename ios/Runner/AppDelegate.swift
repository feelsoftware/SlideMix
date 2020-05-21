import UIKit
import Flutter
import SharedCode

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    // TODO: use DI
    private var movieCreatorChannel: MovieCreatorChannel!
    private var moviesRepositoryChannel: MoviesRepositoryChannel!
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let ffmpegProvider = FFmpegProviderImpl()
    self.movieCreatorChannel = MovieCreatorChannelKt.provideMovieCreatorChannel(ffmpegProvider: ffmpegProvider)
    
    let moviesDBDataSource = MoviesDBDataSourceKt.provideMoviesDBDataSource();
    let moviesRepository = MoviesRepositoryKt.provideMoviesRepository(dbDataSource: moviesDBDataSource);
    self.moviesRepositoryChannel = MoviesRepositoryChannelKt.provideMoviesRepositoryChannel(repository: moviesRepository);
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    registerMovieCreatorChannel(controller: controller)
    registerMoviesRepositoryChannel(controller: controller)
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func registerMovieCreatorChannel(controller : FlutterViewController) {
        let channel = FlutterMethodChannel(name: MovieCreatorChannelCompanion.init().CHANNEL, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self.movieCreatorChannel.methodCall(method: call.method, arguments: call.argumentsMap) { (it: Any) in
                result(it)
            }
        }
    }
    
    private func registerMoviesRepositoryChannel(controller : FlutterViewController) {
        let channel = FlutterMethodChannel(name: MoviesRepositoryChannelCompanion.init().CHANNEL, binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            self.moviesRepositoryChannel.methodCall(method: call.method, arguments: call.argumentsMap) { (it: Any) in
                result(it)
            }
        }
    }
}
