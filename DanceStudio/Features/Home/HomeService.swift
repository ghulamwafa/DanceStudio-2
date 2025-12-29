import Foundation

final class HomeService {

    func fetchClasses() async throws -> [DanceClass] {
        // ✅ Mock mode now (offline)
        return MockData.classes

        // ✅ Later (real API):
        // return try await APIClient.shared.request("classes/")
    }
}
