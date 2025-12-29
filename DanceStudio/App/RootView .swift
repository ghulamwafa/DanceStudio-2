import SwiftUI

struct RootView: View {
    @State private var isLoggedIn = TokenStore.shared.token != nil

    var body: some View {
        Group {
            if isLoggedIn {
                MainTabView {
                    // Logout action
                    isLoggedIn = false
                }
            } else {
                AuthView {
                    // Login success action
                    isLoggedIn = true
                }
            }
        }
    }
}
