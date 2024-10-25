
import Foundation
import Combine

protocol MainViewModelProtocol: AnyObject {
    var imagesPublisher: AnyPublisher<[UnsplashImage], Never> { get }
    var errorPublisher: AnyPublisher<Error?, Never> { get }
    var reloadCollectionView: (() -> Void)? { get set }
    var showNoResults: (() -> Void)? { get set }
    
    func searchImages(query: String)
    func numberOfRows() -> Int
    func configure(cell: UnsplashLayoutCell, forRow row: Int, size: ImageSize)
    func getImage(at index: Int) -> UnsplashImage?
}

final class MainViewModel: MainViewModelProtocol {

    // MARK: State & DI
    
    /* Мы не сможем одновременно использовать свойства с подпиской ($) и реализовывать DI через протокол MainViewModelProtocol, т.к. протокол не понимает, что такое свойства с подпиской (напр., $images). Поэтому нужно менять VM путем создания обертки поверх связанных свойств, чтобы протокол мог их считать. В противном случае можно реализовать DI через создание экземпляра MainViewModel(), но тогда связки на протоколах не получится. */
    
    @Published private(set) var images: [UnsplashImage] = []
    @Published private(set) var error: Error?

    var imagesPublisher: AnyPublisher<[UnsplashImage], Never> {
        $images.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error?, Never> {
        $error.eraseToAnyPublisher()
    }
    
    var reloadCollectionView: (() -> Void)?
    var showNoResults: (() -> Void)?
    
    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    private var isFirstSearch = true
    
    // MARK: Initializers
    
    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }
    
    // MARK: VM Methods
    
    func searchImages(query: String) {
        isFirstSearch = false
        service.fetchImages(query: query)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case let .failure(currentError) = completion {
                        self?.error = currentError
                        print(currentError.localizedDescription)
                    }
                },
                receiveValue: { [weak self] images in
                    self?.images = images
                    self?.reloadCollectionView?()
                    
                    if images.isEmpty && !(self?.isFirstSearch ?? true) {
                        self?.showNoResults?()
                    }
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
        return images[index]
    }
}
