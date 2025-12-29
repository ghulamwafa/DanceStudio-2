import Foundation

enum MockSlots {
    static func slots(for classId: Int) -> [TimeSlot] {
        return [
            TimeSlot(id: classId * 100 + 1, dateTime: "Today 18:00", isAvailable: true),
            TimeSlot(id: classId * 100 + 2, dateTime: "Tomorrow 10:00", isAvailable: true),
            TimeSlot(id: classId * 100 + 3, dateTime: "Tomorrow 19:30", isAvailable: true),
            TimeSlot(id: classId * 100 + 4, dateTime: "Saturday 14:00", isAvailable: false)
        ]
    }
}
