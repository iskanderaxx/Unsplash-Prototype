
import Foundation

final class UnsplashFileManager {
    
    static let shared = UnsplashFileManager()
    private init() {}
    
    // MARK: FM Methods
    
    func saveImage(from imageData: Data, with imageName: String) {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory,
                                                       in: .userDomainMask
        ).first else {
            print(UnsplashError.directoryNotFound.localizedDescription)
            return
        }
        
        let filePath = cacheDirectory.appendingPathComponent("\(imageName).jpg")
        
        do {
            try imageData.write(to: filePath)
        } catch {
            print(UnsplashError.savingError.localizedDescription)
        }
    }
    
    func fileExists(imageName: String) -> Bool {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory,
                                                       in: .userDomainMask
        ).first else { return false }
        
        let filePath = cacheDirectory.appendingPathComponent("\(imageName).jpg")
        return fileManager.fileExists(atPath: filePath.path)
    }
}
