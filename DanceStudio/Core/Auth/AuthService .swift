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

    let role: String          // "student" or "admin"
    let danceLevel: String
    let interests: [String]
}

struct EmptyResponse: Codable {}

final class AuthService {

    //  Change this code anytime
    private let adminCode = "1234"

    func login(email: String, password: String) async throws {

        if AppConfig.useMockAuth {
            let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanPass = password.trimmingCharacters(in: .whitespacesAndNewlines)

            if cleanEmail.isEmpty || cleanPass.isEmpty {
                throw APIError.server("Please enter email and password.")
            }

            // ✅ Admin quick login (optional)
            if cleanEmail.lowercased() == "admin@demo.com" && cleanPass == "admin" {
                SessionStore.shared.login(email: cleanEmail, token: "mock_admin_token", isAdmin: true)
                return
            }

            guard let user = UserStore.shared.findUser(email: cleanEmail, password: cleanPass) else {
                throw APIError.server("Invalid email or password. Please register first.")
            }

            let isAdmin = user.role.lowercased() == "admin"
            SessionStore.shared.login(email: user.email, token: "mock_token_123", isAdmin: isAdmin)
            return
        }

        // ✅ REAL BACKEND (later)
        let res: LoginResponse = try await APIClient.shared.request(
            "auth/login/",
            method: "POST",
            body: LoginRequest(email: email, password: password)
        )
        SessionStore.shared.login(email: email, token: res.token, isAdmin: false)
    }

    func register(_ req: RegisterRequest, adminCodeInput: String?) async throws {

        if AppConfig.useMockAuth {

            // ✅ Protect admin registration
            if req.role.lowercased() == "admin" {
                let input = (adminCodeInput ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
                if input != adminCode {
                    throw APIError.server("Wrong admin code.")
                }
            }

            let user = LocalUser(
                name: req.name,
                email: req.email,
                phone: req.phone,
                password: req.password,
                role: req.role,
                danceLevel: req.danceLevel,
                interests: req.interests
            )

            do {
                try UserStore.shared.register(user: user)
            } catch {
                throw APIError.server(error.localizedDescription)
            }
            return
        }

        // ✅ REAL BACKEND (later)
        let _: EmptyResponse = try await APIClient.shared.request(
            "auth/register/",
            method: "POST",
            body: req
        )
    }

    func logout() {
        SessionStore.shared.logout()
    }
}
