// DanceStudio/Features/Profile/Admin/EditClassView.swift

import SwiftUI

struct EditClassView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var classStore = AdminClassStore.shared

    let danceClass: DanceClass

    @State private var title: String
    @State private var level: String
    @State private var location: String
    @State private var instructorName: String
    @State private var priceText: String
    @State private var capacityText: String
    @State private var description: String
    @State private var imageUrl: String   // ✅ NEW

    private let levels = ["Beginner", "Intermediate", "Advanced"]

    init(danceClass: DanceClass) {
        self.danceClass = danceClass
        _title = State(initialValue: danceClass.title)
        _level = State(initialValue: danceClass.level)
        _location = State(initialValue: danceClass.location)
        _instructorName = State(initialValue: danceClass.instructorName)
        _priceText = State(initialValue: String(danceClass.price))
        _capacityText = State(initialValue: String(danceClass.capacity))
        _description = State(initialValue: danceClass.description)
        _imageUrl = State(initialValue: danceClass.imageUrl ?? "")
    }

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
            .navigationTitle("Edit Class")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let price = Int(priceText) ?? 0
                        let cap = Int(capacityText) ?? 0

                        let updated = DanceClass(
                            id: danceClass.id,
                            title: title.isEmpty ? "New Class" : title,
                            description: description.isEmpty ? "Description..." : description,
                            level: level,
                            location: location,
                            instructorName: instructorName.isEmpty ? "Instructor" : instructorName,
                            price: price,
                            capacity: cap,
                            imageUrl: imageUrl.isEmpty ? nil : imageUrl   // ✅ NEW
                        )

                        classStore.update(updated)
                        dismiss()
                    }
                }
            }
        }
    }
}
