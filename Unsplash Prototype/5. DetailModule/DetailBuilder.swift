
import UIKit

protocol DetailViewBuilderProtocol {
    static func build(with image: UnsplashImage, coordinator: DetailViewCoordinator) -> UIViewController
}

final class DetailViewBuilder: DetailViewBuilderProtocol {

    // MARK: Building detail module
    
    static func build(with image: UnsplashImage, coordinator: DetailViewCoordinator) -> UIViewController {
        let viewModel = DetailViewModel(image: image)
        let detailViewController = DetailViewController(viewModel: viewModel)
        detailViewController.detailViewCoordinator = coordinator
        return detailViewController
    }
}
