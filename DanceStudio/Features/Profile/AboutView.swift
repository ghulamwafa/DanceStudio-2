import SwiftUI

struct AboutView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("Dance Studio CRM & Booking")
                    .font(.title2)
                    .bold()

                Text("This app helps students book dance classes quickly and helps instructors and administrators manage schedules, attendance, and payments.")
                    .foregroundStyle(.secondary)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Key Features").font(.headline)

                    Text("• Login/Register (Demo mode)")
                    Text("• Browse classes")
                    Text("• Book class in 2 taps")
                    Text("• View and cancel bookings")
                    Text("• Favorites + Search + Filters")
                }

                Divider()

                VStack(alignment: .leading, spacing: 6) {
                    Text("Tech").font(.headline)
                    Text("• SwiftUI")
                    Text("• Clean architecture folders")
                    Text("• REST API ready (online backend)")
                }
            }
            .padding()
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}
