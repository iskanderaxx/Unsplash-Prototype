
import UIKit

final class MainViewCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private var appCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }
    
    override func start() {
        print("MainViewCoordinator start вызван")
        let mainViewController = MainModuleBuilder.build(with: self)
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func showDetailView(for image: UnsplashImage) {
        print("Показать детальное представление для изображения: ... ") // 1
        guard let appCoordinator = appCoordinator else { return }
        print("\(image.id)") // 2
        
        let detailViewCoordinator = DetailViewCoordinator(
            navigationController: navigationController,
            appCoordinator: appCoordinator
        )
        addNew(coordinator: detailViewCoordinator)
        detailViewCoordinator.start()
        detailViewCoordinator.showDetail(for: image)
    }
}
