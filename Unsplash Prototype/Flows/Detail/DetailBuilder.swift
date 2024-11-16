
import UIKit

protocol DetailViewBuilderProtocol {
    static func build(with image: UnsplashImage, coordinator: DetailViewCoordinator) -> UIViewController
}

final class DetailViewBuilder: DetailViewBuilderProtocol {
    static func build(with image: UnsplashImage, coordinator: DetailViewCoordinator) -> UIViewController {
        let viewModel = DetailViewModel(image: image, coordinator: coordinator)
        return DetailViewController(viewModel: viewModel)
    }
}
