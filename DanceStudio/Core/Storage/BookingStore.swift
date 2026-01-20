import Foundation
import Combine

final class BookingStore: ObservableObject {
    static let shared = BookingStore()
    private init() {}

    @Published var bookings: [Booking] = []

    //  returns bookingId
    @discardableResult
    func addBooking(classId: Int, classTitle: String, dateTime: String, amount: Int) -> Int {
        let newId = (bookings.first?.id ?? 0) + 1

        let new = Booking(
            id: newId,
            classId: classId,
            classTitle: classTitle,
            dateTime: dateTime,
            status: "confirmed",
            paymentStatus: "unpaid",
            amount: amount
        )
        bookings.insert(new, at: 0)
        return newId
    }

    func cancel(bookingId: Int) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            let b = bookings[index]
            bookings[index] = Booking(
                id: b.id,
                classId: b.classId,
                classTitle: b.classTitle,
                dateTime: b.dateTime,
                status: "canceled",
                paymentStatus: b.paymentStatus,
                amount: b.amount
            )
        }
    }

    // ✅ payment actions
    func markPaid(bookingId: Int) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            let b = bookings[index]
            bookings[index] = Booking(
                id: b.id,
                classId: b.classId,
                classTitle: b.classTitle,
                dateTime: b.dateTime,
                status: b.status,
                paymentStatus: "paid",
                amount: b.amount
            )
        }
    }

    func refund(bookingId: Int) {
        if let index = bookings.firstIndex(where: { $0.id == bookingId }) {
            let b = bookings[index]
            bookings[index] = Booking(
                id: b.id,
                classId: b.classId,
                classTitle: b.classTitle,
                dateTime: b.dateTime,
                status: b.status,
                paymentStatus: "refunded",
                amount: b.amount
            )
        }
    }

    func clear() {
        bookings.removeAll()
    }
}
