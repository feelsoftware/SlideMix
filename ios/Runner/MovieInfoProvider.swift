import Foundation

protocol MovieInfoProvider {
     func provideInfo(outputDir: String) -> MovieInfo?
}

class MovieInfoProviderImpl : MovieInfoProvider {
    func provideInfo(outputDir: String) -> MovieInfo? {
        var uuid = self.generateUUID()
        let files: [String]
        
        do {
            files = try FileManager.default.contentsOfDirectory(atPath: outputDir)
        } catch {
            return nil
        }
        
        while files.any(predicate: { (file:String) -> Bool in
            file.contains(uuid)
        }) {
             uuid = self.generateUUID()
        }
        
        let path = "\(outputDir)/\(uuid)"
        return MovieInfo(thumbPath: "\(path).jpg", moviePath: "\(path).mp4")
    }
    
    private func generateUUID() -> String {
        return UUID.init().uuidString
    }
}

struct MovieInfo {
    let thumbPath: String
    let moviePath: String
}
