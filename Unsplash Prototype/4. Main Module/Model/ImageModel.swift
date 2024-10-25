
import Foundation

struct UnsplashImages: Codable {
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable {
    let id: String
    let urls: ImageURLs
}

struct ImageURLs: Codable {
    let small: String
    let regular: String
    let full: String
    
    func url(for size: ImageSize) -> String {
        switch size {
        case .small:
            small
        case .regular:
            regular
        case .full:
            full
        }
    }
}

enum ImageSize: String {
    case small = "small"
    case regular = "regular"
    case full = "full"
}
