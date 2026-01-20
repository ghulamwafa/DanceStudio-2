// DanceStudio/Models/DanceClass.swift

import Foundation

struct DanceClass: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let level: String
    let location: String
    let instructorName: String
    let price: Int
    let capacity: Int
    let imageUrl: String?   // ✅ NEW (optional image URL)

    // Custom init so old code still works without imageUrl
    init(
        id: Int,
        title: String,
        description: String,
        level: String,
        location: String,
        instructorName: String,
        price: Int,
        capacity: Int,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.level = level
        self.location = location
        self.instructorName = instructorName
        self.price = price
        self.capacity = capacity
        self.imageUrl = imageUrl
    }
}
