
import Foundation
import UIKit

final class DependencyContainer {
    static let shared = DependencyContainer()
    
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var fileManager: FileManagerProtocol = UnsplashFileManager()
    lazy var imageRepository: RepositoryProtocol = ImageRepository()
    
    private init() { }
}
