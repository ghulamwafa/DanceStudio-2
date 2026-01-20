import SwiftUI

struct EditTimeSlotView: View {
    let classId: Int
    let oldText: String

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = TimeSlotStore.shared

    @State private var newText = ""

    var body: some View {
        Form {
            Section("Edit Time") {
                TextField("Example: Monday 18:00", text: $newText)
            }

            Button("Save Changes") {
                let t = newText.trimmingCharacters(in: .whitespacesAndNewlines)
                if !t.isEmpty {
                    store.renameSlot(classId: classId, old: oldText, new: t)
                    dismiss()
                }
            }
        }
        .navigationTitle("Edit Time")
        .onAppear {
            newText = oldText
        }
    }
}
