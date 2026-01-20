// DanceStudio/Features/Profile/Admin/AddClassView.swift

import SwiftUI

struct AddClassView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var classStore = AdminClassStore.shared

    @State private var title = ""
    @State private var level = "Beginner"
    @State private var location = "Room A"
    @State private var instructorName = ""
    @State private var priceText = "5000"
    @State private var capacityText = "20"
    @State private var description = ""
    @State private var imageUrl = ""   // ✅ NEW

    private let levels = ["Beginner", "Intermediate", "Advanced"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Main") {
                    TextField("Title", text: $title)

                    Picker("Level", selection: $level) {
                        ForEach(levels, id: \.self) { Text($0) }
                    }

                    TextField("Location", text: $location)
                    TextField("Instructor Name", text: $instructorName)
                }

                Section("Details") {
                    TextField("Price (₸)", text: $priceText)
                        .keyboardType(.numberPad)

                    TextField("Capacity", text: $capacityText)
                        .keyboardType(.numberPad)

                    TextField("Description", text: $description)
                }

                Section("Image") {
                    TextField("Image URL (optional)", text: $imageUrl)
                        .keyboardType(.URL)
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                }
            }
            .navigationTitle("Add Class")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let price = Int(priceText) ?? 0
                        let cap = Int(capacityText) ?? 0
                        let newId = (classStore.classes.map { $0.id }.max() ?? 0) + 1

                        let item = DanceClass(
                            id: newId,
                            title: title.isEmpty ? "New Class" : title,
                            description: description.isEmpty ? "Description..." : description,
                            level: level,
                            location: location,
                            instructorName: instructorName.isEmpty ? "Instructor" : instructorName,
                            price: price,
                            capacity: cap,
                            imageUrl: imageUrl.isEmpty ? nil : imageUrl   // ✅ NEW
                        )

                        classStore.add(item)
                        dismiss()
                    }
                }
            }
        }
    }
}
