import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
}

struct RegisterRequest: Codable {
    let name: String
    let email: String
    let phone: String
    let password: String
    let danceLevel: String
    let interests: [String]
}

struct EmptyResponse: Codable {}

final class AuthService {

    // ✅ OFFLINE DEMO LOGIN (no backend)
    func login(email: String, password: String) async throws {

        if AppConfig.useMockAuth {
            // Simple demo rule:
            // any email + any password works (or you can make it stricter)
            if email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
               password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                throw APIError.server("Please enter email and password.")
            }

            // Save a fake token so app thinks user is logged in
            TokenStore.shared.token = "mock_token_123"
            return
        }

        // ✅ REAL BACKEND LOGIN (enable later)
        let res: LoginResponse = try await APIClient.shared.request(
            "auth/login/",
            method: "POST",
            body: LoginRequest(email: email, password: password)
        )
        TokenStore.shared.token = res.token
    }

    func register(_ req: RegisterRequest) async throws {

        if AppConfig.useMockAuth {
            // Demo: pretend register succeeds
            return
        }

        let _: EmptyResponse = try await APIClient.shared.request(
            "auth/register/",
            method: "POST",
            body: req
        )
    }

    func logout() {
        TokenStore.shared.clear()
    }
}
