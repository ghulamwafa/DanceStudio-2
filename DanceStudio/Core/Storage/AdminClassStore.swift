import Foundation
import Combine

final class AdminClassStore: ObservableObject {
    static let shared = AdminClassStore()
    private init() {
        self.classes = MockData.classes
    }

    @Published var classes: [DanceClass] = []

    func add(_ item: DanceClass) {
        classes.insert(item, at: 0)
    }

    func update(_ item: DanceClass) {
        if let idx = classes.firstIndex(where: { $0.id == item.id }) {
            classes[idx] = item
        }
    }

    func delete(id: Int) {
        classes.removeAll { $0.id == id }
        TimeSlotStore.shared.removeAllSlots(for: id)
    }
}
