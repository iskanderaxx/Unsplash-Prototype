
import Foundation

final class ImageRepository {
    
    // MARK: State & DI
    
    static let shared = ImageRepository()
    private let fileManager = UnsplashFileManager.shared
    
    private var cachedImages: [String: String?] {
        get {
            UserDefaults.standard.object(forKey: "cachedImages") as? [String: String?] ?? [:]
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "cachedImages")
        }
    }
    
    // MARK: FM Methods
    
    func checkIfCachedImage(for imageName: String) -> String? {
        if let imagePath = cachedImages[imageName], let imagePathUnwrapped = imagePath,
            fileManager.fileExists(imageName: imagePathUnwrapped) {
            return imageName
        }
        return nil
    }
    
    func cacheImage(from data: Data, for imageName: String) {
        fileManager.saveImage(from: data, with: imageName)
        cachedImages[imageName] = imageName
    }
}
