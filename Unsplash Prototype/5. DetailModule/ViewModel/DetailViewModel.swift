
import Foundation

protocol DetailViewModelProtocol: AnyObject {
    var image: UnsplashImage { get }
}

final class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: State & DI
    
    let image: UnsplashImage
    
    // MARK: Initializers
    
    init(image: UnsplashImage) {
        self.image = image
    }
}
