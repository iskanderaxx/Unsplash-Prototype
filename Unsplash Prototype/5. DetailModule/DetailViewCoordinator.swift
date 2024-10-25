
import UIKit

final class DetailViewCoordinator: BaseCoordinator {
    private var navigationController: UINavigationController
    private weak var appCoordinator: AppCoordinator?
    
    init(navigationController: UINavigationController, appCoordinator: AppCoordinator) {
        self.navigationController = navigationController
        self.appCoordinator = appCoordinator
    }
    
    override func start() {
        
    }
    
    func showDetail(for image: UnsplashImage) {
        print("Attempting to present DetailViewController in DetailViewCoordinator")
        let detailViewController = DetailViewBuilder.build(with: image, coordinator: self)
        detailViewController.modalPresentationStyle = .overFullScreen
        navigationController.present(detailViewController, animated: true, completion: nil)
    }
    
    func dismissDetail() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}
