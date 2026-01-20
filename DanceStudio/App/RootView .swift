import SwiftUI

struct RootView: View {
    @ObservedObject private var session = SessionStore.shared

    var body: some View {
        // ✅ Always show the main tabs (Home, Bookings, Profile)
        // No login gate here anymore.
        MainTabView {
            // Called when user taps "Logout" in ProfileView
            session.logout()
        }
    }
}
