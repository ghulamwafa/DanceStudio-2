import Foundation

enum MockData {
    static let classes: [DanceClass] = [
        DanceClass(
            id: 1,
            title: "Hip-Hop Beginners",
            level: "Beginner",
            location: "Room A",
            instructorName: "Amina",
            price: 5000,
            capacity: 20,
            description: "Learn basic hip-hop steps, rhythm, and confidence."
        ),
        DanceClass(
            id: 2,
            title: "Salsa Improvers",
            level: "Intermediate",
            location: "Room B",
            instructorName: "Daniel",
            price: 7000,
            capacity: 16,
            description: "Partner work, musicality, and smooth turns."
        ),
        DanceClass(
            id: 3,
            title: "Ballet Basics",
            level: "Beginner",
            location: "Room C",
            instructorName: "Mira",
            price: 6000,
            capacity: 18,
            description: "Posture, balance, and basic ballet positions."
        ),
        DanceClass(
            id: 4,
            title: "K-Pop Choreo",
            level: "Advanced",
            location: "Room A",
            instructorName: "Jisoo",
            price: 8000,
            capacity: 25,
            description: "Fast choreography, performance, and stamina training."
        )
    ]
}
