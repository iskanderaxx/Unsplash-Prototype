
import Foundation

protocol DetailViewModelProtocol: AnyObject {
    var image: UnsplashImage { get }
    func dismissDetailView()
}

final class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: State & DI
    
    private var coordinator: DetailViewCoordinator
    let image: UnsplashImage
    
    // MARK: Initializers
    
    init(image: UnsplashImage, coordinator: DetailViewCoordinator) {
        self.image = image
        self.coordinator = coordinator
    }
    
    // MARK: VM Methods
    
    func dismissDetailView() {
        coordinator.dismissDetailView()
    }
}
