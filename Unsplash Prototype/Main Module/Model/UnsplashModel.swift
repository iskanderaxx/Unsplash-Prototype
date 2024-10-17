
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
}
