
import Foundation

protocol FileManagerProtocol {
    static var shared: UnsplashFileManager { get }
    func saveImage(from imageData: Data, with imageName: String)
    func fileExists(imageName: String) -> Bool
}

final class UnsplashFileManager: FileManagerProtocol {
    
    // MARK: State & DI
    
    static let shared = UnsplashFileManager()
    private init() {}
    
    static var cacheDirectory: URL? {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    // MARK: FM Methods
    
    func saveImage(from imageData: Data, with imageName: String) {
        guard let cacheDirectory = UnsplashFileManager.cacheDirectory else {
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
        guard let cacheDirectory = UnsplashFileManager.cacheDirectory else { return false }
        
        let filePath = cacheDirectory.appendingPathComponent("\(imageName).jpg")
        return FileManager.default.fileExists(atPath: filePath.path)
    }
}

