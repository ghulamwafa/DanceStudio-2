// DanceStudio/MainTabView.swift

import SwiftUI

struct MainTabView: View {
    let onLogout: () -> Void

    @ObservedObject private var router = TabRouter.shared
    @ObservedObject private var session = SessionStore.shared

    var body: some View {
        TabView(selection: $router.selectedTab) {

            // Always visible
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
                .tag(0)

            // Only show after login
            if session.isLoggedIn {
                MyBookingsView()
                    .tabItem { Label("Bookings", systemImage: "calendar") }
                    .tag(1)

                ProfileView(onLogout: onLogout)
                    .tabItem { Label("Profile", systemImage: "person") }
                    .tag(2)
            }
        }
    }
}
