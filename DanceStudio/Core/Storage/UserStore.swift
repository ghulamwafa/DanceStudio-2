import Foundation

struct LocalUser: Codable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let email: String
    let phone: String
    let password: String

    let role: String          // "student" or "admin"
    let danceLevel: String
    let interests: [String]
}

final class UserStore {
    static let shared = UserStore()
    private init() {}

    private let key = "local_users"

    private var users: [LocalUser] {
        get {
            guard let data = UserDefaults.standard.data(forKey: key) else { return [] }
            return (try? JSONDecoder().decode([LocalUser].self, from: data)) ?? []
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func allUsers() -> [LocalUser] {
        users
    }

    func studentsOnly() -> [LocalUser] {
        users.filter { $0.role.lowercased() == "student" }
    }

    func adminsOnly() -> [LocalUser] {
        users.filter { $0.role.lowercased() == "admin" }
    }

    func register(user: LocalUser) throws {
        var current = users

        if current.contains(where: { $0.email.lowercased() == user.email.lowercased() }) {
            throw NSError(domain: "UserStore", code: 1,
                          userInfo: [NSLocalizedDescriptionKey: "Email already exists."])
        }

        current.append(user)
        users = current
    }

    func findUser(email: String, password: String) -> LocalUser? {
        users.first {
            $0.email.lowercased() == email.lowercased() && $0.password == password
        }
    }

    func deleteUser(id: UUID) {
        var current = users
        current.removeAll { $0.id == id }
        users = current
    }
}
