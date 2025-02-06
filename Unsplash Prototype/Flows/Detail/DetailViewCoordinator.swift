
import UIKit

final class DetailViewCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private var appCoordinator: AppCoordinator
    private var image: UnsplashImage
    
    init(navigationController: UINavigationController, appCoordinator: AppCoordinator, image: UnsplashImage) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
        self.image = image
    }
    
    override func start() {
        showDetail(for: image)
    }
    
    private func showDetail(for image: UnsplashImage) {
        let detailViewController = DetailViewBuilder.build(with: image, coordinator: self)
        detailViewController.modalPresentationStyle = .fullScreen
        navigationController.present(detailViewController, animated: true)
    }
    
    func dismissDetailView() {
        navigationController.dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.appCoordinator.removeCurrent(coordinator: self)
        }
    }
}
