
import Foundation

enum APIModel {
    static let baseUrl = "https://api.unsplash.com"
    static let clientId = "Ip0XA55zY7b7-d19osq1L5btGg-YCeDZVpnnJjXqHxs"
    
    case search(query: String, perPage: Int)
    
    var url: URL? {
        switch self {
        case .search(let query, let perPage):
            var components = URLComponents(string: APIModel.baseUrl)
            components?.path = "/search/photos"
            components?.queryItems = [
                URLQueryItem(name: "client_id", value: APIModel.clientId),
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "per_page", value: "\(perPage)")
            ]
            return components?.url
        }
    }
}
