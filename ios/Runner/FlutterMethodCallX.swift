import Foundation

extension FlutterMethodCall {
    var argumentsMap: [String: Any] {
        return arguments as? [String: Any] ?? [String: Any]()
    }
}
