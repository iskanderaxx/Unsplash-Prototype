
import UIKit

protocol MainBuilderProtocol {
    static func build(with coordinator: MainViewCoordinator) -> UIViewController
}

final class MainBuilder: MainBuilderProtocol {
    static func build(with coordinator: MainViewCoordinator) -> UIViewController {
        let viewModel = MainViewModel(coordinator: coordinator)
        return MainViewController(viewModel: viewModel)
    }
}
