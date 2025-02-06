
import Foundation
import Combine
import UIKit

protocol MainViewModelProtocol: AnyObject {
    var imagesPublisher: AnyPublisher<[UnsplashImage], Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    var reloadCollectionView: (() -> Void)? { get set }
    var resetPlaceholderState: (() -> Void)? { get set }
    var showNoResultsPlaceholder: (() -> Void)? { get set }
    var showError: ((ErrorModel) -> Void)? { get set }
    var showDetailView: ((UnsplashImage) -> Void)? { get }
    var isFirstSearch: Bool { get set }
    var mainViewController: MainViewControllerProtocol? { get set }
    
    func searchImages(query: String)
    func numberOfRows() -> Int
    func configure(cell: UnsplashLayoutCell, forRow row: Int, size: ImageSize)
    func getImage(at index: Int) -> UnsplashImage?
    func showDetailView(for image: UnsplashImage)
    func loadAnotherPage(query: String)
}

final class MainViewModel: MainViewModelProtocol {

    // MARK: State & DI
    
    @Published private(set) var images: [UnsplashImage] = []
    @Published private(set) var error: Error?

    var imagesPublisher: AnyPublisher<[UnsplashImage], Never> {
        $images.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error?, Never> {
        $error.eraseToAnyPublisher()
    }
    
    var coordinator: MainViewCoordinator
    weak var mainViewController: MainViewControllerProtocol?
    private let service: NetworkServiceProtocol
    private var navigationController: UINavigationController?
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 1
    private var isLoading = false
    
    var reloadCollectionView: (() -> Void)?
    var resetPlaceholderState: (() -> Void)?
    var showNoResultsPlaceholder: (() -> Void)?
    var showError: ((ErrorModel) -> Void)?
    var showDetailView: ((UnsplashImage) -> Void)?
    var isFirstSearch = true
    
    // MARK: Initializers
    
    init(service: NetworkServiceProtocol = DependencyContainer.shared.networkService, coordinator: MainViewCoordinator) {
        self.service = service
        self.coordinator = coordinator
    }
    
    // MARK: VM Methods
    
    func searchImages(query: String) {
        isFirstSearch = false
        resetPlaceholderState?()
        service.fetchImages(query: query, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(currentError) = completion {
                        if let error = currentError as? ErrorModel {
                            self?.showError?(error)
                        }
                    }
                },
                receiveValue: { [weak self] images in
                    self?.images = images
                    self?.reloadCollectionView?()
                    
                    if images.isEmpty && !(self?.isFirstSearch ?? true) {
                        self?.showNoResultsPlaceholder?()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func loadAnotherPage(query: String) {
        guard !isLoading else { return }
        isLoading = true
   
        service.fetchImages(query: query, page: currentPage)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.error = error
                    }
                    self?.isLoading = false
                },
                receiveValue: { [weak self] newImages in
                    self?.images.append(contentsOf: newImages)
                    self?.reloadCollectionView?()
                    self?.isLoading = false
                    self?.currentPage += 1
                }
            )
            .store(in: &cancellables)
    }
    
    func numberOfRows() -> Int {
        images.count
    }
    
    func configure(cell: UnsplashLayoutCell, forRow row: Int, size: ImageSize) {
        let image = images[row]
        cell.configure(with: image, size: size)
        
        saveImage(from: image.urls.url(for: size), with: image.id, size: size)
    }
    
    private func saveImage(from url: String, with imageName: String, size: ImageSize) {
        guard let url = URL(string: url) else { return }
        
        let sizeKey = size.rawValue
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                UnsplashFileManager.shared.saveImage(from: data, with: "\(imageName)_\(sizeKey)")
            }
        }
    }
    
    func getImage(at index: Int) -> UnsplashImage? {
        guard index >= 0 && index < images.count else { return nil }
        let image = images[index]
        showDetailView?(image)
        return images[index]
    }
     
    func showDetailView(for image: UnsplashImage) {
        coordinator.showDetailView(for: image)
    }
}
