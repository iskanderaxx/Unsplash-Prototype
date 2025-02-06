
import UIKit

final class MainViewCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private var appCoordinator: AppCoordinator
    
    init(navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }
    
    override func start() {
        let mainViewController = MainBuilder.build(with: self)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showDetailView(for image: UnsplashImage) {
        let detailViewCoordinator = DetailViewCoordinator(
            navigationController: navigationController,
            appCoordinator: appCoordinator, image: image)
        addNew(coordinator: detailViewCoordinator)
        detailViewCoordinator.start()
    }
}
