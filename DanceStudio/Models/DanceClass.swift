import Foundation

struct DanceClass: Identifiable, Codable {
    let id: Int
    let title: String
    let level: String
    let location: String
    let instructorName: String
    let price: Int
    let capacity: Int
    let description: String
}
