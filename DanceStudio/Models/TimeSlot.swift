import Foundation

struct TimeSlot: Identifiable, Codable {
    let id: Int
    let dateTime: String
    let isAvailable: Bool
}
