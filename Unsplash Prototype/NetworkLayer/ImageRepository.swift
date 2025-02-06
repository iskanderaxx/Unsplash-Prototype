
import Foundation

protocol RepositoryProtocol {
    var cachedImages: [String: String?] { get set }
    
    func checkIfCachedImage(for imageName: String) -> String?
    func cacheImage(from data: Data, for imageName: String, errorHandler: ((ErrorModel) -> Void)?)
}

final class ImageRepository: RepositoryProtocol {
    
    // MARK: State & DI
    
    static let shared = ImageRepository()
    let fileManager: FileManagerProtocol
    
    var cachedImages: [String: String?] {
        get {
            UserDefaults.standard.object(forKey: "cachedImages") as? [String: String?] ?? [:]
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: "cachedImages")
        }
    }
    
    // MARK: Initializers
    
    init(fileManager: FileManagerProtocol = DependencyContainer.shared.fileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: Methods
    
    func checkIfCachedImage(for imageName: String) -> String? {
        if let imagePath = cachedImages[imageName], let imagePathUnwrapped = imagePath,
            fileManager.fileExists(imageName: imagePathUnwrapped) {
            return imageName
        }
        return nil
    }
    
    func cacheImage(from data: Data, for imageName: String, errorHandler: ((ErrorModel) -> Void)?) {
        fileManager.saveImage(from: data, with: imageName, errorHandler: { error in
            errorHandler?(error)
        })
        cachedImages[imageName] = imageName
    }
}
