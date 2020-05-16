import Foundation

extension Array {
    func any<T>(predicate: (T) -> Bool) -> Bool {
        if (isEmpty)  {
            return false
        }
        for element in self {
            if (predicate(element as! T)) {
                return true
            }
        }
        return false
    }
}
