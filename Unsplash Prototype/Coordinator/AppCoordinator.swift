
import UIKit

final class AppCoordinator: BaseCoordinator {
    private var window: UIWindow
    
    var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    override func start() {
        let mainCoordinator = MainViewCoordinator(
            navigationController: navigationController, appCoordinator: self
        )
        addNew(coordinator: mainCoordinator)
        mainCoordinator.start()
    }
    
    func returnToPrevious() {
        navigationController.popViewController(animated: true)
    }
}
