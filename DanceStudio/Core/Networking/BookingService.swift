import Foundation

struct BookingPayload: Codable {
    let classTitle: String
    let date: String
    let time: String
    let studentEmail: String
    let adminWhatsApp: String
}

final class BookingService {
    static let shared = BookingService()

    // For simulator:
    // - use 127.0.0.1
    // For real iPhone:
    // - replace with your Mac local IP, e.g. "http://192.168.0.10:8090"
    private let baseURL = URL(string: "http://127.0.0.1:8090")!

    private init() {}

    func createBooking(_ payload: BookingPayload) async throws {
        let url = baseURL.appendingPathComponent("/api/collections/bookings/records")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(["data": payload])

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let http = response as? HTTPURLResponse,
              (200...299).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
