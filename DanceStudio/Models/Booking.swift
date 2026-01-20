import Foundation

struct Booking: Identifiable, Codable {
    let id: Int
    let classId: Int
    let classTitle: String
    let dateTime: String

    let status: String          // "confirmed" / "canceled"
    let paymentStatus: String   // "unpaid" / "paid" / "refunded"
    let amount: Int             // price in ₸
}
