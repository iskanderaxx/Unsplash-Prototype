
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

extension Coordinator {
    func addNew(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeCurrent(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {$0 !== coordinator }
    }
}
