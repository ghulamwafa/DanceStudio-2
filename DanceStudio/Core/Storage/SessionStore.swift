// DanceStudio/Core/SessionStore.swift

import Foundation
import Combine

final class SessionStore: ObservableObject {
    static let shared = SessionStore()
    private init() {}

    @Published var isLoggedIn: Bool = TokenStore.shared.token != nil
    @Published var isAdmin: Bool = false
    @Published var email: String? = nil

    /// Full name of the logged-in user (if known)
    @Published var fullName: String? = nil

    /// Nice display name: prefers fullName, then email before '@', then "Dancer"
    var displayName: String {
        if let name = fullName, !name.trimmingCharacters(in: .whitespaces).isEmpty {
            return name
        }

        if let email = email,
           let firstPart = email.split(separator: "@").first {
            return String(firstPart)
        }

        return "Dancer"
    }

    /// We keep the old parameters and add `fullName` with a default value,
    /// so old calls without fullName still compile.
    func login(email: String, token: String, isAdmin: Bool, fullName: String? = nil) {
        TokenStore.shared.token = token
        self.email = email
        self.fullName = fullName
        self.isAdmin = isAdmin
        self.isLoggedIn = true
    }

    func logout() {
        TokenStore.shared.clear()
        self.email = nil
        self.fullName = nil
        self.isAdmin = false
        self.isLoggedIn = false
    }
}
