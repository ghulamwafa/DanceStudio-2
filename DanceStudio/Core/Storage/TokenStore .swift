import Foundation

final class TokenStore {
    static let shared = TokenStore()
    private init() {}

    private let key = "auth_token"

    var token: String? {
        get { UserDefaults.standard.string(forKey: key) }
        set { UserDefaults.standard.setValue(newValue, forKey: key) }
    }

    func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
