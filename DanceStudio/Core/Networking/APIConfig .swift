import Foundation

enum APIConfig {

    // 🔴 TEMP URL — replace when teacher sends final API
    static let baseURL = URL(string: "https://dance.arlidi.dev/api/v1")!

    static func url(_ path: String) -> URL {
        return baseURL.appendingPathComponent(path)
    }
}
