
import Foundation

protocol FileManagerProtocol {
    func saveImage(from imageData: Data, with imageName: String, errorHandler: ((ErrorModel) -> Void)?)
    func fileExists(imageName: String) -> Bool
}

final class UnsplashFileManager: FileManagerProtocol {
    
    // MARK: State & DI
    
    static let shared = UnsplashFileManager()
    
    static var cacheDirectory: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    // MARK: Methods
    
    func saveImage(from imageData: Data, with imageName: String, errorHandler: ((ErrorModel) -> Void)? = nil) {
        guard let cacheDirectory = UnsplashFileManager.cacheDirectory else {
            errorHandler?(.directoryNotFound)
            return
        }
        
        let filePath = cacheDirectory.appendingPathComponent("\(imageName).jpg")
        
        do {
            try imageData.write(to: filePath)
        } catch {
            errorHandler?(.savingError)
        }
    }
    
    func fileExists(imageName: String) -> Bool {
        guard let cacheDirectory = UnsplashFileManager.cacheDirectory else { return false }
        
        let filePath = cacheDirectory.appendingPathComponent("\(imageName).jpg")
        return FileManager.default.fileExists(atPath: filePath.path)
    }
}

