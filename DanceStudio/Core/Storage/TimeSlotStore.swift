import Foundation
import Combine

final class TimeSlotStore: ObservableObject {
    static let shared = TimeSlotStore.sharedInstance
    private static let sharedInstance = TimeSlotStore()
    private init() {}

    @Published private var slotsByClass: [Int: [String]] = [:]

    func slots(for classId: Int) -> [String] {
        slotsByClass[classId] ?? ["Today 18:00", "Tomorrow 10:00", "Saturday 14:00"]
    }

    func addSlot(classId: Int, timeText: String) {
        var list = slotsByClass[classId] ?? slots(for: classId)
        list.insert(timeText, at: 0)
        slotsByClass[classId] = list
        objectWillChange.send()
    }

    func removeSlot(classId: Int, timeText: String) {
        var list = slotsByClass[classId] ?? []
        list.removeAll { $0 == timeText }
        slotsByClass[classId] = list
        objectWillChange.send()
    }

    func renameSlot(classId: Int, old: String, new: String) {
        var list = slotsByClass[classId] ?? slots(for: classId)
        if let idx = list.firstIndex(of: old) {
            list[idx] = new
            slotsByClass[classId] = list
            objectWillChange.send()
        }
    }

    func removeAllSlots(for classId: Int) {
        slotsByClass[classId] = nil
        objectWillChange.send()
    }
}
