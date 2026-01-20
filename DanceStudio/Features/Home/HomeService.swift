// DanceStudio/Features/Home/HomeService.swift

import Foundation

// This matches the JSON from PocketBase
// {
//   "items": [ { "id": "...", "title": "...", ... } ],
//   "page": 1, ...
// }
private struct PBList<T: Decodable>: Decodable {
    let items: [T]
}

private struct PBClass: Decodable {
    let id: String
    let title: String
    let description: String
    let level: String
    let location: String
    let instructorName: String
    let price: Int
    let capacity: Int
}

/// Service responsible for loading classes from PocketBase.
/// We will map PBClass -> your existing `DanceClass` model.
struct HomeService {

    /// Change this if your PocketBase is not on localhost.
    private let baseURL = URL(string: "http://127.0.0.1:8090")!

    func fetchClasses() async throws -> [DanceClass] {
        // GET /api/collections/classes/records?perPage=30
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.port = baseURL.port
        components.path = "/api/collections/classes/records"
        components.queryItems = [
            URLQueryItem(name: "perPage", value: "30")
        ]

        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let http = response as? HTTPURLResponse,
              (200..<300).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "No body"
            throw APIError.server("PocketBase error: \(body)")
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys

        let pbList = try decoder.decode(PBList<PBClass>.self, from: data)

        // Map PBClass -> your existing DanceClass
        // We generate local Int ids (1, 2, 3, ...) so your app logic still works.
        let mapped: [DanceClass] = pbList.items.enumerated().map { index, item in
            DanceClass(
                id: index + 1,
                title: item.title,
                description: item.description,
                level: item.level,
                location: item.location,
                instructorName: item.instructorName,
                price: item.price,
                capacity: item.capacity
            )
        }

        return mapped
    }
}
