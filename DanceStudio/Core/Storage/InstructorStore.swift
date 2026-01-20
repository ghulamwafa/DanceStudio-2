import Foundation
import Combine

struct Instructor: Identifiable, Codable {
    let id: Int
    let name: String
    let isIndependent: Bool
}

final class InstructorStore: ObservableObject {
    static let shared = InstructorStore()
    private init() {}

    @Published var instructors: [Instructor] = [
        Instructor(id: 1, name: "Amina", isIndependent: false),
        Instructor(id: 2, name: "Daniel", isIndependent: true)
    ]

    func add(name: String, isIndependent: Bool) {
        let newId = (instructors.map { $0.id }.max() ?? 0) + 1
        instructors.insert(Instructor(id: newId, name: name, isIndependent: isIndependent), at: 0)
    }

    func update(id: Int, name: String, isIndependent: Bool) {
        if let idx = instructors.firstIndex(where: { $0.id == id }) {
            instructors[idx] = Instructor(id: id, name: name, isIndependent: isIndependent)
        }
    }

    func delete(id: Int) {
        instructors.removeAll { $0.id == id }
    }
}
