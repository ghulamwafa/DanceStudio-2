// DanceStudio/Resources/MockData.swift

import Foundation

enum MockData {

    /// Fallback / demo classes.
    /// Note: HomeView now loads from PocketBase, but Admin / other views
    /// may still use this mock list.
    static let classes: [DanceClass] = [
        DanceClass(
            id: 1,
            title: "Hip Hop Basic",
            description: "Introduction to hip hop moves and rhythm.",
            level: "Beginner",
            location: "Almaty Studio A",
            instructorName: "Abbas",
            price: 5000,
            capacity: 12
        ),
        DanceClass(
            id: 2,
            title: "Ballet Intermediate",
            description: "Intermediate-level ballet with focus on technique.",
            level: "Intermediate",
            location: "Almaty Studio B",
            instructorName: "Dana",
            price: 6500,
            capacity: 10
        ),
        DanceClass(
            id: 3,
            title: "Salsa Level 1",
            description: "Beginner salsa steps and partnering.",
            level: "Beginner",
            location: "Almaty Studio C",
            instructorName: "Ali",
            price: 5500,
            capacity: 14
        ),
        DanceClass(
            id: 4,
            title: "K-Pop Choreo",
            description: "Learn modern K-Pop choreography.",
            level: "Intermediate",
            location: "Almaty Studio A",
            instructorName: "Zara",
            price: 7000,
            capacity: 16
        )
    ]
}
