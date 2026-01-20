import SwiftUI

struct ProfileView: View {
    let onLogout: () -> Void
    private let auth = AuthService()

    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading) {
                            Text(SessionStore.shared.isAdmin ? "Admin" : "Student")
                                .font(.headline)
                            Text("Demo mode")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("App") {
                    if SessionStore.shared.isAdmin {
                        NavigationLink {
                            AdminPanelView()
                        } label: {
                            Label("Admin Panel", systemImage: "lock.shield")
                        }
                    }

                    NavigationLink { AboutView() } label: {
                        Label("About", systemImage: "info.circle")
                    }

                    NavigationLink { ContactView() } label: {
                        Label("Contact", systemImage: "phone")
                    }
                }

                Section {
                    Button(role: .destructive) {
                        BookingStore.shared.clear()
                        FavoritesStore.shared.clear()
                        auth.logout()
                        onLogout()
                    } label: {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}
