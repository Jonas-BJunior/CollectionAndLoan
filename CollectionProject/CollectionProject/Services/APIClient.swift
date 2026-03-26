import Foundation

/// Central HTTP client used by all API service implementations.
/// Handles encoding, decoding, and HTTP status validation in one place.
final class APIClient {

    static let shared = APIClient()

    // MARK: - Configuration
    // TODO: Replace with your actual base URL when the API is ready.
    let baseURL: URL = URL(string: "https://api.yourdomain.com/v1")!

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init(session: URLSession = .shared) {
        self.session = session

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - GET

    func get<T: Decodable>(_ path: String) async throws -> T {
        let request = try buildRequest(path: path, method: "GET")
        return try await perform(request)
    }

    // MARK: - POST

    func post<Body: Encodable, Response: Decodable>(_ path: String, body: Body) async throws -> Response {
        var request = try buildRequest(path: path, method: "POST")
        request.httpBody = try encodeBody(body)
        return try await perform(request)
    }

    // MARK: - PUT

    func put<Body: Encodable, Response: Decodable>(_ path: String, body: Body) async throws -> Response {
        var request = try buildRequest(path: path, method: "PUT")
        request.httpBody = try encodeBody(body)
        return try await perform(request)
    }

    // MARK: - DELETE (no response body)

    func delete(_ path: String) async throws {
        let request = try buildRequest(path: path, method: "DELETE")
        let (_, response) = try await session.data(for: request)
        try validateStatus(response)
    }

    // MARK: - Helpers

    private func buildRequest(path: String, method: String) throws -> URLRequest {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw ServiceError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: Add Authorization header here when auth is ready:
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }

    private func encodeBody<Body: Encodable>(_ body: Body) throws -> Data {
        do {
            return try encoder.encode(body)
        } catch {
            throw ServiceError.encodingError(error)
        }
    }

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw ServiceError.networkError(error)
        }
        try validateStatus(response)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw ServiceError.decodingError(error)
        }
    }

    private func validateStatus(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse else { return }
        switch http.statusCode {
        case 200...299: break
        case 401:       throw ServiceError.unauthorized
        case 404:       throw ServiceError.notFound
        default:        throw ServiceError.serverError(statusCode: http.statusCode)
        }
    }
}
