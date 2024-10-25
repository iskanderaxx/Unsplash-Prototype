
import UIKit

final class MainViewCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private weak var appCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }
    
    override func start() {
        print("Starting MainViewCoordinator")
        let mainViewController = MainModuleBuilder.build(with: self)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showDetailView(for image: UnsplashImage) {
        guard let appCoordinator = appCoordinator else {
            print("AppCoordinator is nil in MainViewCoordinator")
            return
        }
        
        let detailViewCoordinator = DetailViewCoordinator(
            navigationController: navigationController,
            appCoordinator: appCoordinator
        )
        addNew(coordinator: detailViewCoordinator)
        detailViewCoordinator.showDetail(for: image)
    }
}
