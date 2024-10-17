
import Foundation

// MARK: - URL: https://api.unsplash.com/search/photos?client_id=Ip0XA55zY7b7-d19osq1L5btGg-YCeDZVpnnJjXqHxs&query=snow

final class NetworkService {
    private let baseUrl = "https://api.unsplash.com/search/photos"
    private let clientId = "Ip0XA55zY7b7-d19osq1L5btGg-YCeDZVpnnJjXqHxs"
    
    // Добавлен параметр &per_page=\(perPage) (точнее, &per_page=30), чтобы можно было снять базовое ограничение API на 10 картинок
    func fetchImages(query: String, completion: @escaping (Result<[UnsplashImage], Error>) -> Void) {
        guard let url = URL(string: "\(baseUrl)?client_id=\(clientId)&query=\(query)&per_page=30") else {
            return completion(.failure(UnsplashError.invalidUrl))
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error { return completion(.failure(error)) }
            
            guard let data = data else {
                return completion(.failure(UnsplashError.noData))
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let imagesFetched = try decoder.decode(UnsplashImages.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(imagesFetched.results))
                }
            } catch {
                completion(.failure(UnsplashError.decodingFailure))
            }
        }
        task.resume()
    }
}
