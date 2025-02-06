
import Foundation
import Combine

protocol NetworkServiceProtocol {
    var imageRepository: RepositoryProtocol { get }
    func fetchImages(query: String, page: Int) -> AnyPublisher<[UnsplashImage], Error>
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: State & DI
    
    let imageRepository: RepositoryProtocol
    
    // MARK: Initializers
    
    init(imageRepository: RepositoryProtocol = DependencyContainer.shared.imageRepository) {
        self.imageRepository = imageRepository
    }
    
    // MARK: Methods
    
    func fetchImages(query: String, page: Int = 1) -> AnyPublisher<[UnsplashImage], Error> {
        guard let url = APIModel.search(query: query, perPage: 21, page: page).url else {
            return Fail(error: ErrorModel.invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UnsplashImages.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
