import Foundation

/// Central HTTP client used by all API service implementations.
/// Handles encoding, decoding, and HTTP status validation in one place.
final class APIClient {

    static let shared = APIClient()

    // MARK: - Configuration
    // Local backend URL for iOS Simulator.
    let baseURL: URL = URL(string: "http://127.0.0.1:3000/api/v1/")!

    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init(session: URLSession = .shared) {
        self.session = session

        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let isoFormatter = ISO8601DateFormatter()
            if let date = isoFormatter.date(from: dateString) {
                return date
            }

            let dayFormatter = DateFormatter()
            dayFormatter.calendar = Calendar(identifier: .iso8601)
            dayFormatter.locale = Locale(identifier: "en_US_POSIX")
            dayFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dayFormatter.dateFormat = "yyyy-MM-dd"

            if let date = dayFormatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }

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
        logRequest(request)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            logResponse(data: nil, response: nil, error: error, for: request)
            throw ServiceError.networkError(error)
        }

        logResponse(data: data, response: response, error: nil, for: request)
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

        if let token = AppDependencies.apiBearerToken, !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

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
        logRequest(request)

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            logResponse(data: nil, response: nil, error: error, for: request)
            throw ServiceError.networkError(error)
        }

        logResponse(data: data, response: response, error: nil, for: request)
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

    private func logRequest(_ request: URLRequest) {
#if DEBUG
        print("\n[API] REQUEST ------------------------------")
        print("[API] \(request.httpMethod ?? "-") \(request.url?.absoluteString ?? "-")")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("[API] Headers: \(headers)")
        }

        if let body = request.httpBody,
           !body.isEmpty,
           let bodyString = String(data: body, encoding: .utf8) {
            print("[API] Body: \(bodyString)")
        }
#endif
    }

    private func logResponse(data: Data?, response: URLResponse?, error: Error?, for request: URLRequest) {
#if DEBUG
        print("[API] RESPONSE -----------------------------")
        print("[API] \(request.httpMethod ?? "-") \(request.url?.absoluteString ?? "-")")

        if let http = response as? HTTPURLResponse {
            print("[API] Status: \(http.statusCode)")
            print("[API] Response Headers: \(http.allHeaderFields)")
        }

        if let error {
            print("[API] Error: \(error.localizedDescription)")
        }

        if let data,
           !data.isEmpty,
           let responseBody = String(data: data, encoding: .utf8) {
            print("[API] Response Body: \(responseBody)")
        } else {
            print("[API] Response Body: <empty>")
        }

        print("[API] END ----------------------------------\n")
#endif
    }
}
