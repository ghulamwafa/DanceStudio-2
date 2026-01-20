import SwiftUI

struct AddTimeSlotView: View {
    let classId: Int
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var timeStore = TimeSlotStore.shared

    @State private var timeText = ""

    var body: some View {
        Form {
            Section("New Time Slot") {
                TextField("Example: Monday 18:00", text: $timeText)
            }

            Button("Save") {
                let t = timeText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !t.isEmpty {
                    timeStore.addSlot(classId: classId, timeText: t)
                    dismiss()
                }
            }
        }
        .navigationTitle("Add Time")
    }
}
