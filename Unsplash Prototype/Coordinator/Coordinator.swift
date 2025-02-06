
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    func start()
    func removeToTheInitial(coordinator: Coordinator)
}

extension Coordinator {
    func addNew(coordinator: Coordinator) {
        childCoordinators.append(coordinator)
    }
    
    func removeCurrent(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter {$0 !== coordinator }
    }
    
    func removeToTheInitial(coordinator: Coordinator) {
        // To be implemented here
    }
}
