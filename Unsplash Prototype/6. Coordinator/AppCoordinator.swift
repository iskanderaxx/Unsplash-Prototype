
import UIKit

final class AppCoordinator: BaseCoordinator {
    private var window: UIWindow
    
    private var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func start() {
        let mainViewControllerCoordinator = MainViewCoordinator(
            navigationController: navigationController, appCoordinator: self
        )
        addNew(coordinator: mainViewControllerCoordinator)
        mainViewControllerCoordinator.start()
    }
    
    func returnToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
