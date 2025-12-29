import SwiftUI

struct MainTabView: View {
    let onLogout: () -> Void
    @ObservedObject private var router = TabRouter.shared

    var body: some View {
        TabView(selection: $router.selectedTab) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            MyBookingsView()
                .tabItem { Label("Bookings", systemImage: "calendar") }
                .tag(1)

            ProfileView(onLogout: onLogout)
                .tabItem { Label("Profile", systemImage: "person") }
                .tag(2)
        }
    }
}
