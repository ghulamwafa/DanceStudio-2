import Foundation

// MARK: - Errors
enum APIError: Error {
    case badResponse
    case unauthorized
    case server(String)
    case decoding(Error)
}

// MARK: - API Client
final class APIClient {
    static let shared = APIClient()
    private init() {}

    private var token: String? {
        TokenStore.shared.token
    }

    func request<T: Decodable>(
        _ path: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {

        var request = URLRequest(url: APIConfig.url(path))
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // If logged in, attach token
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Encode body to JSON if exists
        if let body {
            request.httpBody = try JSONEncoder().encode(AnyEncodable(body))
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse else {
            throw APIError.badResponse
        }

        if http.statusCode == 401 {
            throw APIError.unauthorized
        }

        guard (200...299).contains(http.statusCode) else {
            let msg = String(data: data, encoding: .utf8) ?? "Server error"
            throw APIError.server(msg)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decoding(error)
        }
    }
}

// MARK: - Helper to encode any Encodable
struct AnyEncodable: Encodable {
    private let encodeFunc: (Encoder) throws -> Void

    init(_ encodable: Encodable) {
        self.encodeFunc = encodable.encode
    }

    func encode(to encoder: Encoder) throws {
        try encodeFunc(encoder)
    }
}
