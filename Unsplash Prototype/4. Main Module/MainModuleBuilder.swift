
import UIKit

protocol MainModuleBuilderProtocol {
    static func build(with coordinator: MainViewCoordinator) -> UIViewController
}

final class MainModuleBuilder: MainModuleBuilderProtocol {
    
    // MARK: Building main module
    
    static func build(with coordinator: MainViewCoordinator) -> UIViewController {
        let viewModel = MainViewModel(service: NetworkService())
        let mainViewController = MainViewController(viewModel: viewModel)
        
        mainViewController.mainViewCoordinator = coordinator
        print("MainViewCoordinator successfully assigned in MainModuleBuilder")
        return mainViewController
    }
}
