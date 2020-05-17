import Foundation
import SharedCode
import mobileffmpeg

class FFmpegProviderImpl : FFmpegProvider {
    let returnCodeSuccess: Int32 = RETURN_CODE_SUCCESS
    let returnCodeCancel: Int32 = RETURN_CODE_CANCEL
    
    func execute(arguments: [String]) -> Int32 {
        return MobileFFmpeg.execute(withArguments: arguments)
    }
    
    func getMovieDuration(path: String) -> Int64 {
        return Int64(truncating: MobileFFprobe.getMediaInformation(path)?.getDuration() ?? 0)
    }
    
    func cancel() {
        MobileFFmpeg.cancel()
    }
}
