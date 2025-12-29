import SwiftUI

struct MyBookingsView: View {
    @ObservedObject private var store = BookingStore.shared

    var body: some View {
        NavigationStack {
            if store.bookings.isEmpty {
                VStack(spacing: 10) {
                    Text("No bookings yet")
                        .font(.headline)

                    Text("Go to Home and book a class.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding()
                .navigationTitle("Bookings")
            } else {
                List {
                    ForEach(store.bookings) { b in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(b.classTitle)
                                    .font(.headline)
                                Spacer()
                                Text(b.status)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Text(b.dateTime)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            // ✅ Show cancel only if not canceled
                            if b.status != "canceled" {
                                Button(role: .destructive) {
                                    store.cancel(bookingId: b.id)
                                } label: {
                                    Text("Cancel booking")
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
                .navigationTitle("Bookings")
            }
        }
    }
}
