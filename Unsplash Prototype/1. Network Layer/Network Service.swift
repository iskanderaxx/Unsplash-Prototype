
import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchImages(query: String) -> AnyPublisher<[UnsplashImage], Error>
}

final class NetworkService: NetworkServiceProtocol {
    
    // MARK: State & DI
    
    private let imageRepository = ImageRepository.shared
    
    // MARK: NS Methods
    
    func fetchImages(query: String) -> AnyPublisher<[UnsplashImage], Error> {
        guard let url = APIModel.search(query: query, perPage: 30).url else {
            return Fail(error: UnsplashError.invalidUrl).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: UnsplashImages.self, decoder: JSONDecoder())
            .map { $0.results }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
