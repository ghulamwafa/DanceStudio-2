import SwiftUI

struct EditInstructorView: View {
    let instructor: Instructor

    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = InstructorStore.shared

    @State private var name: String = ""
    @State private var isIndependent: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Trainer Info") {
                    TextField("Trainer Name", text: $name)
                    Toggle("Independent trainer", isOn: $isIndependent)
                }

                Button("Save Changes") {
                    let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !n.isEmpty {
                        store.update(id: instructor.id, name: n, isIndependent: isIndependent)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Edit Trainer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .onAppear {
                name = instructor.name
                isIndependent = instructor.isIndependent
            }
        }
    }
}
