import SwiftUI

struct AddInstructorView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var store = InstructorStore.shared

    @State private var name = ""
    @State private var isIndependent = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Trainer Info") {
                    TextField("Trainer Name", text: $name)
                    Toggle("Independent trainer", isOn: $isIndependent)
                }

                Button("Save") {
                    let n = name.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !n.isEmpty {
                        store.add(name: n, isIndependent: isIndependent)
                        dismiss()
                    }
                }
            }
            .navigationTitle("Add Trainer")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}
