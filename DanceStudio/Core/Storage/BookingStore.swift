import Foundation
import Combine

final class BookingStore: ObservableObject {
    static let shared = BookingStore()
    private init() {}

    @Published var bookings: [Booking] = []

    func addBooking(classId: Int, classTitle: String, dateTime: String) {
        let new = Booking(
            id: (bookings.first?.id ?? 0) + 1,
            classId: classId,
            classTitle: classTitle,
            dateTime: dateTime,
            status: "confirmed"
        )
        bookings.insert(new, at: 0)
    }

    // ✅ NEW: Cancel booking
    func cancel(bookingId: Int) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            bookings[index] = Booking(
                id: bookings[index].id,
                classId: bookings[index].classId,
                classTitle: bookings[index].classTitle,
                dateTime: bookings[index].dateTime,
                status: "canceled"
            )
        }
    }

    func clear() {
        bookings.removeAll()
    }
}
