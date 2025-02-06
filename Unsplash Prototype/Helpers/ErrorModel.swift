
import Foundation

enum ErrorModel: Error {
    case invalidUrl
    case noData
    case fetchingFailure
    case decodingFailure
    case directoryNotFound
    case savingError
}
