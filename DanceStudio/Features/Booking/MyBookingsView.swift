// DanceStudio/Features/Booking/MyBookingsView.swift

import SwiftUI

struct MyBookingsView: View {
    @ObservedObject private var store = BookingStore.shared

    @State private var bookingToCancel: Booking?
    @State private var showCancelAlert: Bool = false

    var body: some View {
        NavigationStack {
            Group {
                if store.bookings.isEmpty {
                    emptyState
                } else {
                    bookingsList
                }
            }
            .navigationTitle("My Bookings")
        }
    }

    // MARK: - Empty state

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 40))
                .foregroundColor(.blue.opacity(0.8))

            Text("No bookings yet")
                .font(.headline)

            Text("Find a class on the Home tab and book your first session.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Bookings list

    private var bookingsList: some View {
        List {
            Section("Upcoming & past bookings") {
                ForEach(store.bookings) { b in
                    bookingRow(for: b)
                        .listRowBackground(Color.clear)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.15),
                    Color.purple.opacity(0.1),
                    Color.cyan.opacity(0.18)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
        .alert("Cancel this booking?",
               isPresented: $showCancelAlert,
               presenting: bookingToCancel) { booking in
            Button("Keep", role: .cancel) {}

            Button("Cancel booking", role: .destructive) {
                BookingStore.shared.cancel(bookingId: booking.id)
            }
        } message: { booking in
            Text("This will free up your spot in \(booking.classTitle) on \(booking.dateTime).")
        }
    }

    // MARK: - Single booking row

    private func bookingRow(for b: Booking) -> some View {
        VStack(alignment: .leading, spacing: 8) {

            HStack(alignment: .top) {
                // Leading icon
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.blue.opacity(0.15))
                    Image(systemName: "figure.dance")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                .frame(width: 52, height: 52)

                VStack(alignment: .leading, spacing: 4) {
                    Text(b.classTitle)
                        .font(.headline)

                    Text(b.dateTime)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text("₸\(b.amount)")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }

                Spacer()
            }

            HStack(spacing: 8) {
                // Booking status chip
                statusChip(for: b.status)

                // Payment status chip
                paymentChip(for: b.paymentStatus)

                Spacer()

                // Cancel button (only if not already cancelled)
                if b.status != "cancelled" {
                    Button {
                        bookingToCancel = b
                        showCancelAlert = true
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "xmark.circle")
                            Text("Cancel")
                        }
                        .font(.caption)
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                }
            }
            .padding(.top, 4)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.96))
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        )
        .padding(.vertical, 4)
    }

    // MARK: - Chips

    private func statusChip(for status: String) -> some View {
        let text = status.capitalized

        let (bg, fg): (Color, Color) = {
            switch status.lowercased() {
            case "confirmed":
                return (Color.green.opacity(0.18), Color.green)
            case "cancelled":
                return (Color.gray.opacity(0.2), Color.gray)
            default:
                return (Color.blue.opacity(0.15), Color.blue)
            }
        }()

        return Text(text)
            .font(.caption2)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(bg)
            .foregroundStyle(fg)
            .clipShape(Capsule())
    }

    private func paymentChip(for payment: String) -> some View {
        let upper = payment.uppercased()

        let (bg, fg): (Color, Color) = {
            switch payment.lowercased() {
            case "paid":
                return (Color.green.opacity(0.15), Color.green)
            case "refunded":
                return (Color.orange.opacity(0.15), Color.orange)
            case "pending":
                return (Color.yellow.opacity(0.2), Color.yellow.darker())
            default:
                return (Color.gray.opacity(0.2), Color.gray)
            }
        }()

        return Text("Payment: \(upper)")
            .font(.caption2)
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(bg)
            .foregroundStyle(fg)
            .clipShape(Capsule())
    }
}

// Small helper for darker yellow
fileprivate extension Color {
    func darker() -> Color {
        self.opacity(0.9)
    }
}
