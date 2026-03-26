import Foundation

enum ServiceError: Error, LocalizedError {
    case networkError(Error)
    case decodingError(Error)
    case encodingError(Error)
    case notFound
    case unauthorized
    case serverError(statusCode: Int)
    case invalidURL

    var errorDescription: String? {
        switch self {
        case .networkError(let error):   return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):  return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):  return "Failed to encode request: \(error.localizedDescription)"
        case .notFound:                  return "Resource not found."
        case .unauthorized:              return "Unauthorized. Please log in again."
        case .serverError(let code):     return "Server error (HTTP \(code))."
        case .invalidURL:                return "Invalid URL."
        }
    }
}
